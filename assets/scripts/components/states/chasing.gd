extends State

@export var patrolling: State
@export var damaging: State

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	parent.navigation_agent.target_position = parent.player_ref.global_position
	parent.update_movement()

	if not parent.can_see_player(parent.damage_component.detection_range):
		return patrolling
		
	if parent.can_see_player(parent.damage_component.attack_range):
		return damaging
		
	parent.move_and_slide()
	
	return null
	


	
