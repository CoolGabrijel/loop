extends Area3D
class_name Pickup


@export var sprite_2d: Sprite2D

signal player_entered


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		emit_signal("player_entered")
