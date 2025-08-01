extends CanvasLayer

@onready var play_button: Button = $ButtonHolder/PlayButton
@onready var settings_button: Button = $ButtonHolder/SettingsButton
@onready var quit_game_button: Button = $ButtonHolder/QuitGameButton

@onready var main_menu: CanvasLayer = $"."

func _on_play_button_pressed() -> void:
	main_menu.hide()
