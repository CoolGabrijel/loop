extends Area3D

@onready var player: Player = $Player


func _on_body_entered(body: Node3D) -> void:
	player.health.heal(5)
