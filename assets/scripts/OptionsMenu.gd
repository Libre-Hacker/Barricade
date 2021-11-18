extends CanvasLayer

signal level_changed

func _on_Back_button_down():
	emit_signal("level_changed", "PreviousLevel")
