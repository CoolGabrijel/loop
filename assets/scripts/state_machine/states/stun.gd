extends State

@export var chasing: State 

func enter() -> void:
	parent.damage_component.attack_range = parent.melee_attack_range

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	if parent.can_see_player(parent.damage_component.attack_range) == null:
		return chasing
	
	Player.player.controller.stun(parent.damage_component.stun_attack_duration)
	
	return chasing
