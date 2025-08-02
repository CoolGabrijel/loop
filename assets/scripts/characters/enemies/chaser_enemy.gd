extends CharacterBody3D
class_name chaser_enemy

@onready var state_machine: Node = $StateMachine
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent
@onready var debug_label: Label3D = $DebugLabel
@onready var damaged_sfx: AudioStreamPlayer = $"Chaser is Damaged Sound"

@onready var speed_component: Speed = $SpeedComponent
@onready var damage_component: Damage = $DamageComponent
@onready var health_component: Health = $HealthComponent

@export var health: float = 30.0
@export var speed: float = 4.0

@export_group("Object References")
@export var patrol_points: NodePath

@export_group("Combat")
@export var attack_damage: int
@export var attack_speed: float
@export var detection_range: float
@export var attack_range: float

var waypoints: Array[Vector3] = []
var current_waypoint: int = 0

func _ready() -> void:
	if !Player.player:
		queue_free()
	
	state_machine.init(self)
	
	_create_waypoints()
	
	health_component.base_max_hp = health
	speed_component.speed = speed
	
	damage_component.attack_damage = attack_damage
	damage_component.attack_speed = attack_speed
	damage_component.detection_range = detection_range
	damage_component.attack_range = attack_range
	



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
	
		velocity = direction * speed_component.total_speed
		
func can_see_player(view_range: float) -> bool:
	var parent_pos: Vector3 = global_position
	var player_pos: Vector3 = Player.player.global_position
	
	var distance = parent_pos.distance_to(player_pos)
	
	return distance <= view_range

func drop_health_pickup() -> void:
	const PICKUP = preload("res://scenes/objects/effects/pickup_health.tscn")
	var pickup: Node3D = PICKUP.instantiate()
	get_tree().current_scene.add_child(pickup)
	pickup.global_position = global_position
	pickup.show()
	print("Chaser Enemy :: Dropped Health at " + str(global_position))

func _on_damaged() -> void:
	damaged_sfx.play()

func _on_death() -> void:
	drop_health_pickup()
	queue_free()
