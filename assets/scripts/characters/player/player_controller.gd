extends Node

@export_flags_3d_physics var mouse_pos_mask
@export_group("Footstep SFX Settings")
@export var volume: float = 1
@export var pitch: float = 1
@export var pitch_variance: float = 0.1
@export var volume_variance: float = 0.1

@onready var slash: MeshInstance3D = $"../Damage/Area3D/CollisionShape3D/MeshInstance3D"
@onready var player: Player = $".."
@onready var sprite: AnimatedSprite3D = $"../AnimatedSprite3D"
@onready var walking_sounds: AudioStreamPlayer = $"../MC_Marching"
@onready var camera: Camera3D = $"../Camera3D"

# For showing status effects, like stun
@onready var debug_label: Label3D = $"../DebugLabel"

var movement_input: Vector2
var movement_locked: bool = false

func _physics_process(delta: float) -> void:
	if movement_locked == false and !player.is_dead:
		update_movement_input()
		handle_movement(delta)
	update_sprite()
	handle_footstep_sfx()
	handle_damage_component()
	
	if player.is_dead:
		debug_label.text = "Fired. Again."

func _unhandled_input(event: InputEvent) -> void:
	if !event.is_action_pressed("Attack"):
		return
	
	player.damage_node.deal_damage()
	_play_punch_anim()

func handle_movement(delta: float) -> void:
	var normalized_input = movement_input.normalized()
	var dir = Vector3(normalized_input.x, 0, normalized_input.y)
	player.velocity = dir * delta * player.speed_component.total_speed
	player.move_and_slide()

func handle_damage_component() -> void:
	var mouse_pos := _get_mouse_pos_in_3d()
	mouse_pos.y = player.damage_node.global_position.y
	
	if player.damage_node.position == mouse_pos:
		return
	
	player.damage_node.look_at(mouse_pos)

func update_movement_input() -> void:
	movement_input.x = Input.get_axis("Left", "Right")
	movement_input.y = Input.get_axis("Up", "Down")

func handle_footstep_sfx() -> void:
	if player.velocity != Vector3.ZERO and !walking_sounds.playing:
		walking_sounds.pitch_scale = randf_range(pitch - pitch_variance, pitch + pitch_variance)
		walking_sounds.volume_db = randf_range(volume - volume_variance, volume - volume_variance)
		walking_sounds.play()
		if !sprite.is_playing() or sprite.animation == "idle" or sprite.animation == "punch":
			sprite.play("walking")
	elif player.velocity == Vector3.ZERO:
		walking_sounds.stop()
		if sprite.animation != "punch":
			sprite.play("idle")

func update_sprite() -> void:
	if movement_input.x >= 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
		
func stun(duration: float) -> void:
	movement_locked = true
	debug_label.text = "Stunned"
	sprite.play("hurt")
	await get_tree().create_timer(duration).timeout
	sprite.play("idle")
	movement_locked = false
	debug_label.text = ""

func _play_punch_anim() -> void:
	slash.show()
	sprite.play("punch")
	await get_tree().create_timer(0.2).timeout
	slash.hide()
	sprite.play("idle")

func _get_mouse_pos_in_3d() -> Vector3:
	var space_state := player.get_world_3d().direct_space_state
	var mouse_pos := get_viewport().get_mouse_position()
	var from := camera.project_ray_origin(mouse_pos)
	var to := camera.project_ray_normal(mouse_pos) * 1000
	var query := PhysicsRayQueryParameters3D.create(from, to, mouse_pos_mask)
	var result := space_state.intersect_ray(query)
	
	if !result:
		return Vector3.ZERO
	
	if result["collider"] != null:
		return result["position"]
	return Vector3.ZERO
