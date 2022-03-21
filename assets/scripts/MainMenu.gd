extends CanvasLayer
# Handles main menu input.

export (AudioStream) var music = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)  # Show cursor but confine to window.
	AudioManager.new_music(music)

# Starts the game with the selected level.
func _on_Start_button_up():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Hides cursor.
	GameManager.start_game()

# Loads the options menu.
func _on_Options_button_up():
	MenuSwitcher.load_scene("res://assets/scenes/OptionsMenu.tscn")

# Shows the quit confirm popup.
func _on_Quit_button_up():
	get_node("Popup").popup()
