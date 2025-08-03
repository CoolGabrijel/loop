extends CanvasLayer

@export var heart_full: Texture2D
@export var heart_half: Texture2D
@export var heart_empty: Texture2D
@export var heart_rects: Array[TextureRect]

@onready var minimap: Sprite2D = $Minimap
@onready var energy_bar: ProgressBar = $EnergyBar
@onready var buff_container: HBoxContainer = $BuffContainer

@onready var area_2d: Area2D = $Minimap/Area2D

var can_click: bool

signal show_map


func _process(delta: float) -> void:
	_update_hp()

func _update_hp() -> void:
	if !Player.player:
		return
	
	var hearts: Array[TextureRect]
	for rect in heart_rects:
		hearts.append(rect)
	
	var max_hp := Player.player.health_node.base_max_hp
	var cur_hp := Player.player.health_node.current_hp
	var hp_ratio: float = float(max_hp) / float(cur_hp)
	
	for i in range(hearts.size()):
		var rect := hearts[i]
		var ratio: float = float(hearts.size()) / float(i)
		if ratio > hp_ratio:
			rect.texture = heart_full
		else:
			rect.texture = heart_empty

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and can_click:
		emit_signal("show_map")
		can_click = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	can_click = true
