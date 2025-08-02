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
	parent.move_and_slide()
	
	if parent.can_see_player(parent.damage_component.detection_range) == false:
		return patrolling
	
	# Retreat and After Shoot, Guard use that instead of default range attack
	if parent.state_machine.enable_combination_shoot_stun and parent.can_see_player(parent.range_attack_range):	
		parent.state_machine.has_stun_combination_finished = false
		if parent.can_see_player((parent.range_attack_range + parent.melee_attack_range) / 2):
			return retreat
		return shoot
	
	# Stun Attack
	if (parent.state_machine.has_stun_combination_finished == false) and parent.can_see_player(parent.melee_attack_range):
		parent.state_machine.has_stun_combination_finished = true
		return stun
	
	# Default states of attacking
	if parent.can_see_player(parent.damage_component.attack_range):
		
		# Range Attack
		if (parent.damage_component.is_range_attack) and (parent.state_machine.is_combination_enabled == false):
			return shoot
		
		# Melee Attack
		if (parent.damage_component.is_range_attack == false):
			return melee
		
	return null
	


	
