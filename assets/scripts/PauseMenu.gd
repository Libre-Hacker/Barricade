extends CanvasLayer

const menuOpened = preload("res://assets/resources/menu_opened.tres")
signal level_changed
signal menu_closed

func _on_Options_button_down():
	emit_signal("level_changed", "OptionsMenu")

func _on_Resume_button_up():
	emit_signal("level_changed", "")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Lock mouse to game screen.
	menuOpened.Value = false
