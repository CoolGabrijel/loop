extends State

@export var chasing: State 

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.navigation_agent.is_navigation_finished(): 
		if parent.waypoints.is_empty():
			return
	
		parent.navigation_agent.target_position = parent.waypoints[parent.current_waypoint]
		parent.current_waypoint = (parent.current_waypoint + 1) % parent.waypoints.size()
	
	parent.update_movement()
	parent.move_and_slide()
	
	if parent.can_see_player(parent.damage_component.detection_range):
		return chasing
	
	return null
