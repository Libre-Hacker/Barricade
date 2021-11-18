extends CanvasLayer

signal return_to_MainMenu

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
func _on_ReturnToMainMenu_button_up():
	emit_signal("return_to_MainMenu")
