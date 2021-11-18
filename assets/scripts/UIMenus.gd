extends Node
const gameStarted = preload("res://assets/resources/game_started.tres")
const menuOpened = preload("res://assets/resources/menu_opened.tres")

func _unhandled_input(event):
	if(gameStarted.Value == false):
		return
	if(event.is_action_pressed("pause")):
		if(menuOpened.Value):
			get_node("SceneSwitcher").unload_level()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Lock mouse to game screen.
			menuOpened.Value = false
			
		else:
			menuOpened.Value = true
			get_node("SceneSwitcher")._on_level_changed("PauseMenu")
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED) # Show mouse but confine it to the window.
