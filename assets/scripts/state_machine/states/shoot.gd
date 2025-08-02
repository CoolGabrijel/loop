extends State

@export var chasing: State 
@export var stun: State

func enter() -> void:
	if parent.state_machine.is_combination_enabled:
		parent.damage_component.attack_range = parent.range_attack_range

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.can_see_player(parent.damage_component.attack_range) == false:
		return chasing
		
	if parent.state_machine.can_attack:
		shoot()
		parent.state_machine.reset_attack_timer()
		
		if parent.state_machine.enable_combination_shoot_stun and stun:
			# Immediately block combo reuse
			parent.reset_combination_timer()
			return chasing
		
	return null
	
func shoot() -> void:
	var shoot_position: Vector3 = parent.global_position
	var shoot_direction: Vector3 = parent.global_position.direction_to(Player.player.global_position)
	
	SignalHub.emit_on_create_bullet(
		shoot_position, shoot_direction,
		parent.damage_component.bullet_speed,
		parent.damage_component.attack_damage
	)
	
