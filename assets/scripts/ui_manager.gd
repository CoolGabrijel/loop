extends CanvasLayer

@export var main_menu_scene: PackedScene
@export var volume_control_menu_scene: PackedScene
@export var hud_scene: PackedScene

func _ready() -> void:
	var main_menu = main_menu_scene.instantiate()
	add_child(main_menu)
