extends Button
# Changes the ui and updates the settings file for the assigned key bind.

enum INPUT_SETTINGS{move_forward, move_backward, move_left, move_right, jump,
					phase, interact, reload, rotate_prop, primary_fire,
					alt_fire, next_weapon, previous_weapon}

export (INPUT_SETTINGS) var assignedAction

var inputChange = false # Enables bind changing logic.
var mouseInputText = ["LMB","RMB","MMB", "SCROLL UP", "SCROLL DOWN"] # Mouse input to text translation.

onready var keyBindSettingIndex = Settings.settings.keyBinds[0].find(INPUT_SETTINGS.keys()[assignedAction])

func _ready():
	load_setting()

# Display the setting value on the UI.
func load_setting():
	if(Settings.settings.keyBinds[1][keyBindSettingIndex] <= 5):
		text = mouseInputText[Settings.settings.keyBinds[1][keyBindSettingIndex] - 1] # Subtract 1 because mouse keys start at 1, but mouseInputText starts at 0.
	else:
		text = OS.get_scancode_string(Settings.settings.keyBinds[1][keyBindSettingIndex]).to_upper()

# Accepts input, updates UI, and updates the setting file. 
func _unhandled_input(event: InputEvent):
	if(event is InputEventMouseMotion): # Ignore mouse motion input.
		return
	
	# Only accept input if inputChange is true.
	if(inputChange):
		inputChange = false
		if(event is InputEventMouseButton):
			var buttonIndex = event.get_button_index() - 1 # Subtract 1 because mouse keys start at 1, but mouseInputText starts at 0.
			text = mouseInputText[buttonIndex]
			Settings.settings.keyBinds[1][keyBindSettingIndex] = event.get_button_index()
		else:
			text = OS.get_scancode_string(event.scancode).to_upper()
			Settings.settings.keyBinds[1][keyBindSettingIndex] = event.scancode
			
		Settings.apply_input_settings()

# Prepare to accept new input.
func _on_KeyButton_button_up():
	text = "Press a Key..."
	inputChange = true

