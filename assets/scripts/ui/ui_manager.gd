extends CanvasLayer
class_name UIManager

static var instance : UIManager

@export var main_menu_scene: PackedScene
@export var volume_control_menu_scene: PackedScene
@export var hud_scene: PackedScene
@export var fullscreen_game_map_scene: PackedScene
@export var credits_scene: PackedScene
@export var intro_scene: PackedScene
@export var end_game_scene: PackedScene
@export var victory_scene: PackedScene

@onready var main_menu = main_menu_scene.instantiate()
@onready var hud = hud_scene.instantiate()
@onready var options = volume_control_menu_scene.instantiate()
@onready var credits = credits_scene.instantiate()
@onready var map = fullscreen_game_map_scene.instantiate()
@onready var intro = intro_scene.instantiate()
@onready var end_game = end_game_scene.instantiate()
@onready var victory = victory_scene.instantiate()
@onready var player: Player = $"../Player"
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

func _ready() -> void:
	player.set_process_input(false)
	instance = self
	
	add_child(main_menu)
	add_child(hud)
	add_child(options)
	add_child(map)
	add_child(credits)
	add_child(intro)
	add_child(end_game)
	add_child(victory)
	
	main_menu.hide()
	hud.hide()
	map.hide()
	options.hide()
	credits.hide()
	end_game.hide()
	victory.hide()
	
	main_menu.play_button_was_pressed.connect(_on_play_button_pressed)
	main_menu.options_button_was_pressed.connect(_on_options_button_pressed)
	main_menu.credits_button_was_pressed.connect(_on_credits_button_pressed)
	options.back_button_was_pressed.connect(_on_back_button_pressed)
	credits.back_button_was_pressed.connect(_on_back_button_pressed)
	hud.show_map.connect(_on_show_map)
	intro.intro_has_ended.connect(_on_intro_ended)
	end_game.restart_button_pressed.connect(_on_restart_button_pressed)


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_play_button_pressed() -> void:
	hud.show()
	main_menu.hide()
	player.set_process_input(true)
	audio_stream_player.play()

func _on_death() -> void:
	end_game.show()

func _on_victory() -> void:
	victory.show()

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


func _on_intro_ended() -> void:
	main_menu.show()



func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.is_pressed():
			main_menu.show()
			hud.hide()
			options.hide()
			credits.hide()
