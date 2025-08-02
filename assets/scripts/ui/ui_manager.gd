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
	add_child(options)
	add_child(map)
	add_child(credits)
	
	hud.hide()
	map.hide()
	options.hide()
	credits.hide()
	
	main_menu.play_button_was_pressed.connect(_on_play_button_pressed)
	main_menu.options_button_was_pressed.connect(_on_options_button_pressed)
	main_menu.credits_button_was_pressed.connect(_on_credits_button_pressed)
	options.back_button_was_pressed.connect(_on_back_button_pressed)
	credits.back_button_was_pressed.connect(_on_back_button_pressed)
	hud.show_map.connect(_on_show_map)


func _on_play_button_pressed() -> void:
	hud.show()


func _on_options_button_pressed() -> void:
	options.show()


func _on_credits_button_pressed() -> void:
	credits.show()


func _on_back_button_pressed() -> void:
	options.hide()
	credits.hide()
	main_menu.show()


func _on_show_map() -> void:
	map.show()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.is_pressed():
			main_menu.show()
			hud.hide()
			options.hide()
			credits.hide()
