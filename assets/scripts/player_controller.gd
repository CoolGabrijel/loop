extends Node

@export var base_speed : float = 5
@export_group("Footstep SFX Settings")
@export var volume: float = 1
@export var pitch: float = 1
@export var pitch_variance: float = 0.1
@export var volume_variance: float = 0.1

@onready var player: CharacterBody3D = $".."
@onready var sprite: AnimatedSprite3D = $"../AnimatedSprite3D"
@onready var walking_sounds: AudioStreamPlayer = $"../MC_Marching"

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


func handle_movement(delta: float) -> void:
	var normalized_input = movement_input.normalized()
	var dir = Vector3(normalized_input.x, 0, normalized_input.y)
	player.velocity = dir * delta * base_speed
	player.move_and_slide()


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
