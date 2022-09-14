extends CheckBox
# Handles state of the assigned setting.

enum VIDEO_SETTINGS {fullscreen, borderless, vsync}

export (VIDEO_SETTINGS) var assignedSetting
onready var settingIndex = Settings.settings.videoSettings[0].find(VIDEO_SETTINGS.keys()[assignedSetting])

func _ready():
	load_setting()

# Display the setting value on the UI.
func load_setting():
	pressed = Settings.settings.videoSettings[1][settingIndex]

# Applies the state of this checkbox to the setting.
func _on_pressed():
	Settings.settings.videoSettings[1][settingIndex] = pressed
	Settings.apply_settings()
