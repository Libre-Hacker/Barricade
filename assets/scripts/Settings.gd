extends Node

const FILE_PATH = "res://assets/resources/custom_settings.tres"

var settings = ResourceLoader.load("res://assets/resources/default_settings.tres")

func _init():
	load_settings()

func load_settings(default = false):
	if(ResourceLoader.exists(FILE_PATH) and default == false):
		settings = ResourceLoader.load(FILE_PATH)
	else:
		settings = ResourceLoader.load("res://assets/resources/default_settings.tres")
		print("Error: Customs settings not found. Using defaults.")
	apply_settings()
	
func apply_settings():
	OS.window_fullscreen = settings.fullscreen
	OS.window_borderless = settings.borderless
	OS.window_size = settings.resolution
	OS.window_position = OS.get_screen_size(0) * 0.5 - OS.get_window_size() * 0.5
	OS.vsync_enabled = settings.vsync
	AudioServer.set_bus_volume_db(0, linear2db(settings.masterVolume))
	AudioServer.set_bus_volume_db(1, linear2db(settings.musicVolume))
	AudioServer.set_bus_volume_db(2, linear2db(settings.soundVolume))
	for input in InputMap.get_actions():
		print(input)
		var i = -1
		for keyBind in settings.keyBinds[0]:
			i += 1
			if(input == keyBind):
				print(keyBind)
				print(settings.keyBinds[1][i])
				InputMap.action_erase_events(keyBind)
				if(settings.keyBinds[1][i] <= 5):
					var new_event = InputEventMouseButton.new()
					new_event.set_button_index(settings.keyBinds[1][i])
					InputMap.action_add_event(input, new_event)
				else:
					var new_event = InputEventKey.new()
					new_event.set_scancode(settings.keyBinds[1][i])
					InputMap.action_add_event(input, new_event)
		i = -1

func save_settings():
	print("saving settings")
	ResourceSaver.save(FILE_PATH, settings)
