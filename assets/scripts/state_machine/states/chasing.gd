extends State

@export var patrolling: State
@export var melee: State
@export var shoot: State
@export var stun: State
@export var retreat: State

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	parent.navigation_agent.target_position = Player.player.global_position
	parent.update_movement()

	if not parent.can_see_player(parent.damage_component.detection_range):
		return patrolling
	
	if parent.state_machine.enable_combination_shoot_stun and parent.can_see_player(parent.range_attack_range):	
		parent.state_machine.has_stun_combination_finished = false
		if parent.can_see_player((parent.range_attack_range + parent.melee_attack_range) / 2):
			return retreat
		return shoot
		
	if !parent.state_machine.is_combination_enabled and parent.can_see_player(parent.damage_component.attack_range):
		return shoot
	
	if (not parent.state_machine.has_stun_combination_finished) and parent.can_see_player(parent.melee_attack_range):
		parent.state_machine.has_stun_combination_finished = true
		return stun
	
	if parent.can_see_player(parent.damage_component.attack_range):
		return melee
		
	parent.move_and_slide()
	
	return null
	


	
