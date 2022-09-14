extends CheckBox
# Handles state of the assigned setting.

enum MISC_SETTINGS {tutorials}

export (MISC_SETTINGS) var assignedSetting

onready var settingIndex = Settings.settings.miscSettings[0].find(MISC_SETTINGS.keys()[assignedSetting])


func _ready():
	load_setting()


# Display the setting value on the UI.
func load_setting():
	pressed = Settings.settings.miscSettings[1][settingIndex]


# Applies the state of this checkbox to the setting.
func _on_pressed():
	Settings.settings.miscSettings[1][settingIndex] = pressed
	Settings.apply_settings()
