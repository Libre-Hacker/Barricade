extends CanvasLayer
# Handles input for pause menu.

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED) # Show cursor but confine to window.

# Allows player to unpause with the "pause" action.
func _unhandled_key_input(event: InputEventKey):
	if(event.is_action_pressed("pause")):
		_on_Resume_button_up()

# Resumes game.
func _on_Resume_button_up():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Hide cursor.
	GameManager.resume_game()

# Loads the options menu.
func _on_Options_button_up():
	MenuSwitcher.load_scene("res://assets/scenes/OptionsMenu.tscn")

# Shows the quit confirm popup.
func _on_Quit_button_up():
	get_node("Popup").popup()
