extends Node

@export_flags_3d_physics var mouse_pos_mask
@export_group("Footstep SFX Settings")
@export var volume: float = 1
@export var pitch: float = 1
@export var pitch_variance: float = 0.1
@export var volume_variance: float = 0.1

@onready var player: Player = $".."
@onready var sprite: AnimatedSprite3D = $"../AnimatedSprite3D"
@onready var walking_sounds: AudioStreamPlayer = $"../MC_Marching"
@onready var camera: Camera3D = $"../Camera3D"

# For showing status effects, like stun
@onready var debug_label: Label3D = $"../DebugLabel"

var movement_input: Vector2
var movement_locked: bool = false

func _physics_process(delta: float) -> void:
	if movement_locked == false:
		update_movement_input()
		handle_movement(delta)
	update_sprite()
	handle_footstep_sfx()
	handle_damage_component()

func _unhandled_input(event: InputEvent) -> void:
	if !event.is_action_pressed("Attack"):
		return
	
	player.damage_node.deal_damage()

func handle_movement(delta: float) -> void:
	var normalized_input = movement_input.normalized()
	var dir = Vector3(normalized_input.x, 0, normalized_input.y)
	player.velocity = dir * delta * player.speed_component.total_speed
	player.move_and_slide()

func handle_damage_component() -> void:
	var mouse_pos := _get_mouse_pos_in_3d()
	mouse_pos.y = player.damage_node.global_position.y
	player.damage_node.look_at(mouse_pos)

func update_movement_input() -> void:
	movement_input.x = Input.get_axis("Left", "Right")
	movement_input.y = Input.get_axis("Up", "Down")

func handle_footstep_sfx() -> void:
	if movement_input != Vector2.ZERO and !walking_sounds.playing:
		walking_sounds.pitch_scale = randf_range(pitch - pitch_variance, pitch + pitch_variance)
		walking_sounds.volume_db = randf_range(volume - volume_variance, volume - volume_variance)
		walking_sounds.play()
	elif movement_input == Vector2.ZERO:
		walking_sounds.stop()

func update_sprite() -> void:
	if movement_input.x >= 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
		
func stun(duration: float) -> void:
	movement_locked = true
	debug_label.text = "Stunned"
	await get_tree().create_timer(duration).timeout
	movement_locked = false
	debug_label.text = ""

func _get_mouse_pos_in_3d() -> Vector3:
	var space_state := player.get_world_3d().direct_space_state
	var mouse_pos := get_viewport().get_mouse_position()
	var from := camera.project_ray_origin(mouse_pos)
	var to := camera.project_ray_normal(mouse_pos) * 1000
	var query := PhysicsRayQueryParameters3D.create(from, to, mouse_pos_mask)
	var result := space_state.intersect_ray(query)
	
	if result["collider"] != null:
		return result["position"]
	return Vector3.ZERO
