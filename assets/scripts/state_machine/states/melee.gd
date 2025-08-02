extends State

@export var chasing: State

func enter() -> void:
	if parent.state_machine.is_combination_enabled:
		parent.damage_component.attack_range = parent.melee_attack_range
		
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
		Player.player.health_node.damage(parent.damage_component.attack_damage)
		parent.state_machine.reset_attack_timer()

	return null
