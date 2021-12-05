extends Button

export var assignedAction = "move_forward"
onready var keyBindSettingIndex = Settings.settings.keyBinds[0].find(assignedAction)
var inputChange = false
signal setting_changed
signal input_changed
var mouseInputText = ["LMB","RMB","MMB", "SCROLL UP", "SCROLL DOWN"]

func _ready():
	print(keyBindSettingIndex)
	load_settings()

func load_settings():
	if(Settings.settings.keyBinds[1][keyBindSettingIndex] <= 5):
		print("Bind =", mouseInputText[Settings.settings.keyBinds[1][keyBindSettingIndex] - 1])
		text = mouseInputText[Settings.settings.keyBinds[1][keyBindSettingIndex] - 1]
	else:
		print("Bind =", OS.get_scancode_string(Settings.settings.keyBinds[1][keyBindSettingIndex]).to_upper())
		text = OS.get_scancode_string(Settings.settings.keyBinds[1][keyBindSettingIndex]).to_upper()


func _unhandled_input(event: InputEvent):
	if(event is InputEventMouseMotion):
		return

	if(inputChange):
		emit_signal("setting_changed")
		inputChange = false
		if(event is InputEventMouseButton):
			print(event.get_button_index())
			var buttonIndex = event.get_button_index() - 1
			text = mouseInputText[buttonIndex]
			remap_to_button(event)
		else:
			text = OS.get_scancode_string(event.scancode).to_upper()
			remap_to_key(event)

func remap_to_key(event):
		var input_events = InputMap.get_action_list(assignedAction)
		for event in input_events:
			InputMap.action_erase_event(assignedAction, event)
		var new_event = InputEventKey.new()
		new_event.set_scancode(event.scancode)
		InputMap.action_add_event(assignedAction, new_event)
		Settings.settings.keyBinds[1][keyBindSettingIndex] = event.scancode
		print(event.scancode)
		print(OS.get_scancode_string(Settings.settings.keyBinds[1][keyBindSettingIndex]).to_upper())

func remap_to_button(event):
	var input_events = InputMap.get_action_list(assignedAction)
	for event in input_events:
		InputMap.action_erase_event(assignedAction, event)
	var new_event = InputEventMouseButton.new()
	new_event.set_button_index(event.get_button_index())
	InputMap.action_add_event(assignedAction, new_event)
	Settings.settings.keyBinds[1][keyBindSettingIndex] = event.get_button_index()

func _on_KeyButton_button_up():
	text = "Press a Key..."
	inputChange = true

