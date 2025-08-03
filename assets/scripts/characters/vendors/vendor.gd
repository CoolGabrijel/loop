extends Node3D
class_name Vendor

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var time_till_disappear: Timer = $TimeTillDisappear

@onready var label: Label = $CanvasLayer/Label

signal on_player_enter

# add lines based on the inherited npc
@export var dialogue_lines: Array[String] = [
	
]

var current_line: int = 0
var player_is_in := false

func _ready() -> void:
	canvas_layer.hide()
	time_till_disappear.timeout.connect(dialogue_end)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		canvas_layer.show()
		time_till_disappear.start()
		display_random_dialogue()
		on_player_enter.emit()
		# add buffs 

func display_random_dialogue() -> void:
	label.text = dialogue_lines[randi_range(0, dialogue_lines.size()-1)]

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and player_is_in:
		advance_dialogue()


func update_dialogue():
	label.text = dialogue_lines[current_line]


func advance_dialogue():
	current_line += 1
	if current_line < dialogue_lines.size():
		update_dialogue()
	else: 
		queue_free()

func dialogue_end() -> void:
	queue_free()
