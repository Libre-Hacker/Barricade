extends HSlider
# Handles state of the assigned setting.

enum AUDIO_SETTINGS {Master, Music, Sound}

export (AUDIO_SETTINGS) var assignedSetting
onready var settingIndex = Settings.settings.audioSettings[0].find(AUDIO_SETTINGS.keys()[assignedSetting])

func _ready():
	load_setting()

# Display the setting value on the UI.
func load_setting():
	value = Settings.settings.audioSettings[1][settingIndex]

# Applies the value of this slider to settings.
func _on_value_changed(volume: float):
	Settings.settings.audioSettings[1][settingIndex] = value
	Settings.apply_settings()
