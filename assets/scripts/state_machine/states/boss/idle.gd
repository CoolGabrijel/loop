extends State

@export var slam_attack: State
@export var sweep_attack: State
@export var melee: State

var previous_state: State

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.can_see_player(parent.melee_attack_range):
		parent.damage_component.attack_range = parent.melee_attack_range
		return melee 
		
	parent.damage_component.attack_range = parent.attack_range
	if (parent.can_slam_attack) and (previous_state != slam_attack) and (parent.state_machine.can_attack):
		previous_state = slam_attack
		return slam_attack
		
	if (parent.can_sweep_attack) and (previous_state != sweep_attack) and (parent.state_machine.can_attack):
		previous_state = sweep_attack
		return sweep_attack
	
	return null
