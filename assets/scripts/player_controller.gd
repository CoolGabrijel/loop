extends Node

@export var base_speed : float = 5

@onready var player: CharacterBody3D = $".."

var movement_input : Vector2

func _physics_process(delta: float) -> void:
	update_movement_input()
	handle_movement(delta)

func handle_movement(delta: float) -> void:
	var normalized_input = movement_input.normalized()
	var dir = Vector3(normalized_input.x, 0, normalized_input.y)
	player.velocity = dir * delta * base_speed
	player.move_and_slide()

func update_movement_input() -> void:
	movement_input.x = Input.get_axis("Left", "Right")
	movement_input.y = Input.get_axis("Up", "Down")
	
