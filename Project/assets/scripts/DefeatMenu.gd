extends CanvasLayer
# Handles input for the defeat menu.

export (AudioStream) var music = null
export (Resource) var clickSound = null


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED) # Show cursor but confine to window.
	get_node("AudioManager").new_music(music)

# Loads main menu.
func _on_ReturnToMainMenu_button_up():
	AudioManager.new_sound(clickSound)
	MenuSwitcher.load_scene("res://assets/scenes/MainMenu.tscn")

# Shows the quit confirm popup.
func _on_Quit_button_up():
	AudioManager.new_sound(clickSound)
	get_node("Popup").popup()


func _on_ui_pressed():
	AudioManager.new_sound(clickSound)
