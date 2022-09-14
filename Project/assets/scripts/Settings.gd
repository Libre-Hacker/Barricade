extends Node
# Loads, saves, and applies settings from the loaded setting resource.

const FILE_PATH = "res://assets/resources/custom_settings.tres" # Path to the custom setting resource.

var settings # The setting resource file.

func _init():
	load_settings()

# Loads the custom setting resource if it exists, or the default settings.
func load_settings(default = false):
	settings = null # Required for default reset to work.
	if(ResourceLoader.exists(FILE_PATH) and default == false):
		settings = ResourceLoader.load(FILE_PATH)
	else:
		settings = ResourceLoader.load("res://assets/resources/default_settings.tres")
		#print("Error: Customs settings not found. Using defaults.")
	apply_settings()

# Applies the loaded settings to the game.
func apply_settings():
	apply_video_settings()
	apply_audio_settings()
	apply_input_settings()

# Applies just the video settings.
func apply_video_settings():
	OS.window_fullscreen = settings.videoSettings[1][0]
	OS.window_borderless = settings.videoSettings[1][1]
	OS.window_size = settings.videoSettings[1][2]
	OS.window_position = OS.get_screen_size(0) * 0.5 - OS.get_window_size() * 0.5
	OS.vsync_enabled = settings.videoSettings[1][3]

# Applies just the audio settings.
func apply_audio_settings():
	var i = 0
	for setting in settings.audioSettings[0]:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(setting), linear2db(settings.audioSettings[1][i]))
		i += 1

# Applies just the input settings.
func apply_input_settings():
	for input in InputMap.get_actions():
		var i = -1
		for keyBind in settings.keyBinds[0]:
			i += 1
			if(input == keyBind):
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

# Saves / overwrites the custom setting resource.
func save_settings():
	ResourceSaver.save(FILE_PATH, settings)
