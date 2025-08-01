extends Node

@export var base_speed : float = 5

@onready var player: CharacterBody3D = $".."
@onready var sprite: AnimatedSprite3D = $"../AnimatedSprite3D"
@onready var walking_sounds: AudioStreamPlayer = $"../MC_Marching"

var movement_input: Vector2


func _physics_process(delta: float) -> void:
	update_movement_input()
	handle_movement(delta)
	update_sprite()


func handle_movement(delta: float) -> void:
	var normalized_input = movement_input.normalized()
	var dir = Vector3(normalized_input.x, 0, normalized_input.y)
	player.velocity = dir * delta * base_speed
	player.move_and_slide()


func update_movement_input() -> void:
	movement_input.x = Input.get_axis("Left", "Right")
	movement_input.y = Input.get_axis("Up", "Down")
		
	if movement_input != Vector2.ZERO and !walking_sounds.playing:
		walking_sounds.pitch_scale = randf_range(0.75, 1.25)
		walking_sounds.volume_db = randf_range(0.75, 1.25)
		walking_sounds.play()
	elif movement_input == Vector2.ZERO:
		walking_sounds.stop()
	

func update_sprite() -> void:
	if movement_input.x >= 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
