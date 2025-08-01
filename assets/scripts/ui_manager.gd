extends CanvasLayer

@export var main_menu_scene: PackedScene
@export var volume_control_menu_scene: PackedScene
@export var hud_scene: PackedScene
@export var fullscreen_game_map_scene: PackedScene
@export var credits_scene: PackedScene

@onready var main_menu = main_menu_scene.instantiate()
@onready var hud = hud_scene.instantiate()
@onready var options = volume_control_menu_scene.instantiate()
@onready var credits = credits_scene.instantiate()
@onready var map = fullscreen_game_map_scene.instantiate()


func _ready() -> void:
	add_child(main_menu)
	add_child(hud)
	hud.hide()
	
	main_menu.play_button_was_pressed.connect(_on_play_button_pressed)
	main_menu.options_button_was_pressed.connect(_on_options_button_pressed)
	main_menu.credits_button_was_pressed.connect(_on_credits_button_pressed)


func _on_play_button_pressed():
	hud.show()


func _on_options_button_pressed():
	options.show()


func _on_credits_button_pressed():
	credits.show()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.is_pressed():
			main_menu.show()
			hud.hide()
			options.hide()
			credits.hide()
