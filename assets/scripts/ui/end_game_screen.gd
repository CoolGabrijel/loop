extends CanvasLayer

signal restart_button_pressed


func _on_button_pressed() -> void:
	emit_signal("restart_button_pressed")
