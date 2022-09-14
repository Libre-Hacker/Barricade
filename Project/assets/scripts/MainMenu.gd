extends CanvasLayer
# Handles main menu input.

export (AudioStream) var music = null
export (Resource) var clickSound = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)  # Show cursor but confine to window.
	AudioManager.new_music(music)

# Starts the game with the selected level.
func _on_Start_button_up():
	AudioManager.new_sound(clickSound)
	Network.create_server()
	GameManager.start_game()

# Loads the options menu.
func _on_Options_button_up():
	AudioManager.new_sound(clickSound)
	MenuSwitcher.load_scene("res://assets/scenes/OptionsMenu.tscn")

# Shows the quit confirm popup.
func _on_Quit_button_up():
	AudioManager.new_sound(clickSound)
	get_node("Popup").popup()


func _on_ui_pressed():
	AudioManager.new_sound(clickSound)


func _on_Wishlist_button_up():
	var res = OS.shell_open("steam://advertise/2006180")
	if(res != OK):
		OS.shell_open("https://store.steampowered.com/app/2006180/Barricade/")
	
	get_tree().quit()

func _on_Multiplayer_button_up():
	AudioManager.new_sound(clickSound)
	MenuSwitcher.load_scene("res://assets/scenes/MultiplayerMenu.tscn")
