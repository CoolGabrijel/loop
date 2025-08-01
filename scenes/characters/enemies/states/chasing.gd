extends State

@export var Patrolling: State

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

	if not parent.can_see_player():
		return Patrolling
		
	parent.move_and_slide()
	
	return null


	
