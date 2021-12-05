extends Tabs

var unsavedChanges = false

signal setting_changed

onready var fullscreenCheckbox = get_node("VBoxContainer/HBoxContainer/FullscreenCheckBox")
onready var borderlessCheckbox = get_node("VBoxContainer/HBoxContainer_2/BorderlessCheckBox")
onready var resolutionOption = get_node("VBoxContainer/HBoxContainer_3/ResolutionOptionButton")
onready var vsyncCheckbox = get_node("VBoxContainer/HBoxContainer_4/VsyncCheckBox")

func _ready():
	load_settings()

func load_settings():
	fullscreenCheckbox.pressed = Settings.settings.fullscreen
	borderlessCheckbox.pressed = Settings.settings.borderless
	for index in resolutionOption.get_item_count():
		if(resolutionOption.get_item_text(index) == str(Settings.settings.resolution.x) + "x" + str(Settings.settings.resolution.y)):
			resolutionOption.selected = index
	vsyncCheckbox.pressed = Settings.settings.vsync

func _on_FullscreenCheckBox_pressed():
	OS.window_fullscreen = fullscreenCheckbox.pressed
	Settings.settings.fullscreen = fullscreenCheckbox.pressed
	emit_signal("setting_changed")

func _on_BorderlessCheckBox_pressed():
	OS.window_borderless = borderlessCheckbox.pressed
	Settings.settings.borderless = borderlessCheckbox.pressed
	emit_signal("setting_changed")

func _on_ResolutionOptionButton_item_selected(index: int):
	var values = resolutionOption.text.split_floats("x")
	OS.window_size = Vector2(values[0],values[1])
	OS.window_position = OS.get_screen_size(0) * 0.5 - OS.get_window_size() * 0.5
	Settings.settings.resolution = Vector2(values[0],values[1])
	emit_signal("setting_changed")

func _on_VsyncCheckBox_pressed():
	OS.vsync_enabled = vsyncCheckbox.pressed
	Settings.settings.vsync = vsyncCheckbox.pressed
	emit_signal("setting_changed")

