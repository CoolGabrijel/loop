extends CharacterBody3D
class_name guard_enemy

@onready var state_machine: Node = $StateMachine
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent
@onready var debug_label: Label3D = $DebugLabel
@onready var combination_timer: Timer = $CombinationTimer

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
@export var bullet_speed: float
@export var stun_attack_duration: float
@export var retreat_speed_multiplier: float

@export_group("Range")
@export var detection_range: float
@export var melee_attack_range: float
@export var range_attack_range: float
@export var retreat_range_multiplier: float

# Cooldown of shoot and stun sequence attack
@export var combination_attack_cooldown: float

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
	damage_component.attack_range = melee_attack_range
	damage_component.stun_attack_duration = stun_attack_duration
	damage_component.combination_attack_cooldown = combination_attack_cooldown
	damage_component.bullet_speed = bullet_speed
	
	combination_timer.wait_time = combination_attack_cooldown
	
	
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
	
		velocity = direction * speed_component.speed
		
func can_see_player(view_range: float) -> bool:
	var parent_pos: Vector3 = global_position
	var player_pos: Vector3 = Player.player.global_position
	
	var distance = parent_pos.distance_to(player_pos)
	
	return distance <= view_range

#func _on_damaged() -> void:
	#damaged_sfx.play()

func _on_death() -> void:
	queue_free()

func reset_combination_timer() -> void:
	state_machine.enable_combination_shoot_stun = false
	combination_timer.start()

func _on_combination_timer_timeout() -> void:
	state_machine.enable_combination_shoot_stun = true
