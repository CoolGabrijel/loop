extends CharacterBody3D
class_name boss

@onready var state_machine: Node = $StateMachine
@onready var debug_label: Label3D = $DebugLabel

@onready var slam_attack_timer: Timer = $SlamAttackTimer
@onready var sweep_attack_timer: Timer = $SweepAttackTimer

@onready var damage_component: Damage = $DamageComponent
@onready var health_component: Node3D = $HealthComponent

@export var health: float = 30.0

@export_group("Combat")
@export var attack_damage: int
@export var attack_speed: float
@export var attack_range: float

@export var slam_attack_damage: float
@export var sweep_attack_damage: float
@export var slam_attack_cooldown: float
@export var sweep_attack_cooldown: float
	
var can_slam_attack: bool = false
var can_sweep_attack: bool = false

func _ready() -> void:
	if !Player.player:
		queue_free()
	
	state_machine.init(self)
	
	health_component.base_max_hp = health
	
	damage_component.attack_damage = attack_damage
	damage_component.attack_speed = attack_speed
	damage_component.attack_range = attack_range
	
	slam_attack_timer.wait_time = slam_attack_cooldown
	sweep_attack_timer.wait_time = sweep_attack_cooldown
	
	slam_attack_timer.start()
	sweep_attack_timer.start()
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)


func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func can_see_player(view_range: float) -> bool:
	var can_see_player: bool = false
	
	var parent_pos: Vector3 = global_position
	var player_pos: Vector3 = Player.player.global_position
	
	var distance = parent_pos.distance_to(player_pos)
	
	if distance <= view_range:
		can_see_player = true
	
	return can_see_player

func reset_slam_attack_timer() -> void:
	can_slam_attack = false
	slam_attack_timer.start()

func reset_sweep_attack_timer() -> void:
	can_sweep_attack = false
	sweep_attack_timer.start()
	
func _on_slam_attack_timer_timeout() -> void:
	can_slam_attack = true

func _on_sweep_attack_timer_timeout() -> void:
	can_sweep_attack = true

func _on_death() -> void:
	UIManager.instance._on_victory()
