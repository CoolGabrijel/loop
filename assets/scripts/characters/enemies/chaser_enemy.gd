extends CharacterBody3D
class_name chaser_enemy

@onready var state_machine: Node = $StateMachine
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent
@onready var debug_label: Label3D = $DebugLabel
@onready var damaged_sfx: AudioStreamPlayer = $"Chaser is Damaged Sound"

@export var pickup_scene: PackedScene
@export var player_ref: CharacterBody3D
@export var patrol_points: NodePath
@export var movement_speed : float = 10.0

@export var detection_range: float = 100.0
@export var attack_range: float = 10.0

var waypoints: Array[Vector3] = []
var current_waypoint: int = 0

func _ready() -> void:
	if !player_ref:
		queue_free()
	
	state_machine.init(self)
	
	_create_waypoints()

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _create_waypoints() -> void:
	for child in get_node(patrol_points).get_children():
		waypoints.append(child.global_position)

func update_movement() -> void:
	if navigation_agent.is_navigation_finished(): 
		return
	else:
		var next_path_position: Vector3 = navigation_agent.get_next_path_position()
		var local_destination = next_path_position - global_position
		var direction = local_destination.normalized()
	
		velocity = direction * movement_speed
		
func can_see_player() -> bool:
	var parent_pos = global_position
	var player_pos = player_ref.global_position
	
	var direction = (player_pos - global_position).normalized()
	var distance = parent_pos.distance_to(player_pos)
	
	return distance <= detection_range

func _on_damaged() -> void:
	damaged_sfx.play()


# pickup is lost in time and space
func _on_death() -> void:
	var pickup: Node3D = pickup_scene.instantiate()
	get_tree().current_scene.add_child(pickup)
	pickup.global_position = global_position
	pickup.show()
	print("Chaser Enemy :: Dropped Health")
	queue_free()
