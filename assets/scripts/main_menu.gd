extends CanvasLayer

@onready var play_button: Button = $ButtonHolder/PlayButton
@onready var settings_button: Button = $ButtonHolder/SettingsButton
@onready var quit_game_button: Button = $ButtonHolder/QuitGameButton

@onready var main_menu: CanvasLayer = $"."

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.is_pressed():
			main_menu.show()


func _on_play_button_pressed():
	main_menu.hide()


func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
