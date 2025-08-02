extends Node3D
class_name Vendor


@onready var label: Label = $Label

signal player_is_in

# add lines based on the inherited npc
var dialogue_lines: Array = [
	
]

var current_line: int = 0


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		emit_signal("player_is_in")
		# add buffs 


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		advance_dialogue()


func update_dialogue():
	label.text = dialogue_lines[current_line]


func advance_dialogue():
	current_line += 1
	if current_line < dialogue_lines.size():
		update_dialogue()
	else: 
		queue_free()
