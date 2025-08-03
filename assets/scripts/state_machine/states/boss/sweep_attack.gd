extends State

@export var idle: State

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.can_see_player(parent.damage_component.attack_range) == false:
		return idle
		
	parent.state_machine.reset_attack_timer()
	parent.reset_sweep_attack_timer()
		
	return idle
	
