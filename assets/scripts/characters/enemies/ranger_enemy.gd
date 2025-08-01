extends CharacterBody3D
class_name ranger_enemy

@onready var state_machine: Node = $StateMachine
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent
@onready var debug_label: Label3D = $DebugLabel
@onready var player_detection: RayCast3D = $PlayerDetection

@onready var speed_component: Speed = $SpeedComponent
@onready var damage_component: Damage = $DamageComponent
@onready var health_component: Node3D = $HealthComponent

@export var health: float = 30.0
@export var speed: float = 4.0

@export_group("Object References")
@export var player_ref: CharacterBody3D
@export var patrol_points: NodePath

@export_group("Combat")
@export var attack_damage: int
@export var attack_speed: float
@export var detection_range: float
@export var attack_range: float
@export var bullet_speed: float


var waypoints: Array[Vector3] = []
var current_waypoint: int = 0

func _ready() -> void:
	if !player_ref:
		queue_free()
	
	state_machine.init(self)
	
	_create_waypoints()
	
	health_component.base_max_hp = health
	speed_component.speed = speed
	
	damage_component.attack_damage = attack_damage
	damage_component.attack_speed = attack_speed
	damage_component.detection_range = detection_range
	damage_component.attack_range = attack_range
	damage_component.bullet_speed = bullet_speed
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	update_raycast()
	

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _create_waypoints() -> void:
	for child in get_node(patrol_points).get_children():
		waypoints.append(child.global_position)

func update_raycast() -> void:
	player_detection.look_at(player_ref.global_position)
	
func player_is_visible() -> bool:
	return player_detection.get_collider() is Player

func update_movement() -> void:
	if navigation_agent.is_navigation_finished(): 
		return
	else:
		var next_path_position: Vector3 = navigation_agent.get_next_path_position()
		var local_destination = next_path_position - global_position
		var direction = local_destination.normalized()
	
		velocity = direction * speed_component.speed
		
func can_see_player(view_range: float) -> bool:
	var can_see_player: bool = false
	
	var parent_pos: Vector3 = global_position
	var player_pos: Vector3 = player_ref.global_position
	
	var distance = parent_pos.distance_to(player_pos)
	
	if player_is_visible() and distance <= view_range:
		can_see_player = true
	
	return can_see_player
	
