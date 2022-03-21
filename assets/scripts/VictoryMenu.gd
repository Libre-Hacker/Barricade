extends CanvasLayer
# Handles input for the victory menu.
export (AudioStream) var music = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED) # Show cursor but confine to window.
	get_node("AudioManager").new_music(music)
	
	# Loads main menu.
func _on_ReturnToMainMenu_button_up():
	MenuSwitcher.load_scene("res://assets/scenes/MainMenu.tscn")

# Shows the quit confirm popup.
func _on_Quit_button_up():
	get_node("Popup").popup()
