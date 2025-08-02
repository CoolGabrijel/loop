extends CanvasLayer

@onready var back_button: Button = $BackButton

signal back_button_was_pressed


func _on_back_button_pressed() -> void:
	emit_signal("back_button_was_pressed")
