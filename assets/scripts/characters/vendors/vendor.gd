extends Node3D

@onready var label: Label = $Label

# add lines based on the inherited npc
var dialogue_lines: Array = [
	
]

var current_line = 0


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		pass
