extends State

@onready var damage_cooldown_timer: Timer = $DamageCooldownTimer

@export var chasing: State

var _can_attack: bool = true

func enter() -> void:
	damage_cooldown_timer.wait_time = parent.damage_component.attack_speed
	damage_cooldown_timer.start()

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:

	if not parent.can_see_player(parent.damage_component.attack_range):
		return chasing
		
	if parent.damage_component.is_range_attack == false:
		deal_damage(parent.damage_component.attack_damage)
	else:
		var shoot_posistion: Vector3 = parent.global_position
		var shoot_direction: Vector3 = parent.global_position.direction_to(parent.player_ref.global_position)
		
		shoot(shoot_posistion, shoot_direction)
	
	return null
	
func deal_damage(attack_damage: float) -> void:
	if _can_attack:
		parent.player_ref.health_node.damage(attack_damage)
		reset_timer()

func shoot(shoot_position: Vector3, direction: Vector3) -> void:
	if _can_attack:
		SignalHub.emit_on_create_bullet(
			shoot_position, direction,
			parent.damage_component.bullet_speed,
			parent.damage_component.attack_damage
		)
		reset_timer()
	
func reset_timer() -> void:
	_can_attack = false
	damage_cooldown_timer.start()

func _on_attack_cooldown_timeout() -> void:
	_can_attack = true
