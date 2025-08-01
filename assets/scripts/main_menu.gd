extends CanvasLayer

@onready var play_button: Button = $ButtonHolder/PlayButton
@onready var settings_button: Button = $ButtonHolder/SettingsButton
@onready var quit_game_button: Button = $ButtonHolder/QuitGameButton

var pause_menu_is_showing: bool

signal play_button_was_pressed
signal options_button_was_pressed

func _on_play_button_pressed() -> void:
	hide()
	emit_signal("play_button_was_pressed")


func _on_settings_button_pressed() -> void:
	emit_signal("options_button_was_pressed")


func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
