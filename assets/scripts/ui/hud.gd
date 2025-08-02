extends CanvasLayer

@onready var minimap: Sprite2D = $Minimap
@onready var energy_bar: ProgressBar = $EnergyBar
@onready var buff_container: HBoxContainer = $BuffContainer
@onready var hearts_container: HBoxContainer = $HeartsContainer

var can_click: bool = false

signal show_map


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and can_click:
		emit_signal("show_map")
		can_click = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	can_click = true
