extends State

@export var patrolling: State
@export var chasing: State

var starting_speed: float = 0.0
var retreat_dir: Vector3
var retreat_pos: Vector3

func enter() -> void:
	starting_speed = parent.speed_component.base_speed

	retreat_dir = (parent.global_position - Player.player.global_position).normalized()
	retreat_pos = parent.global_position + retreat_dir * parent.retreat_range_multiplier
	parent.navigation_agent.target_position = retreat_pos
	
	parent.speed_component.base_speed *= parent.retreat_speed_multiplier
	
	
func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	parent.update_movement()
	parent.move_and_slide()
	
	if parent.navigation_agent.is_navigation_finished():
		parent.speed_component.base_speed = starting_speed
		return chasing
	
	return null
