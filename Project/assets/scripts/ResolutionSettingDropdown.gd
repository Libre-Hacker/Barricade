extends OptionButton
# Handles state of the resolution setting.

var assignedSetting = "resolution"
onready var settingIndex = Settings.settings.videoSettings[0].find(assignedSetting)

func _ready():
	load_setting()

# Display the setting value on the UI.
func load_setting():
	for index in get_item_count():
		if(get_item_text(index) == str(Settings.settings.videoSettings[1][settingIndex].x) + "x" + str(Settings.settings.videoSettings[1][settingIndex].y)):
			selected = index

# Updates the setting and displays the changes.
func _on_item_selected(index: int):
	var values = text.split_floats("x")
	Settings.settings.videoSettings[1][settingIndex] = Vector2(values[0],values[1])
	Settings.apply_settings()
