extends State

@export var slam_hitbox_scene: PackedScene
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

	spawn_slam_attack()
	
	parent.state_machine.reset_attack_timer()
	parent.reset_slam_attack_timer()
	
	return idle

func spawn_slam_attack() -> void:
	var new_slam_hitbox_scene = slam_hitbox_scene.instantiate()
	parent.add_child(new_slam_hitbox_scene)
	new_slam_hitbox_scene.global_position = Player.player.global_position
