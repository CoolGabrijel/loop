extends CanvasLayer

@onready var back_button: Button = $BackButton
@onready var master_volume_slider: HSlider = $MasterVolumeSlider
@onready var sfx_slider: HSlider = $SFXSlider
@onready var music_volume_slider: HSlider = $MusicVolumeSlider
@onready var dialogue_slider: HSlider = $DialogueSlider

signal back_button_was_pressed


func _on_back_button_pressed() -> void:
	emit_signal("back_button_was_pressed")


func _on_master_volume_slider_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_sfx_slider_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_music_volume_slider_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_dialogue_slider_value_changed(value: float) -> void:
	pass # Replace with function body.
