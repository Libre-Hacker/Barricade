extends CanvasLayer
# Handles input for the options menu,
# Reqests default settings to be loaded.

export (Resource) var clickSound = null

func _on_ResetToDefault_button_up():
	get_node("ConfirmationDialog").popup()

# Saves settings and loads the previous scene.
func _on_Back_button_up():
	Settings.save_settings()
	MenuSwitcher.load_previous_scene()

# Confirms reset to default settings.
func _on_ConfirmationDialog_confirmed():
	Settings.load_settings(true)
	Settings.save_settings()
	get_tree().call_group("setting_control", "load_setting")

func _on_ui_pressed():
	AudioManager.new_sound(clickSound)

func _on_ui_item_selected(index):
	AudioManager.new_sound(clickSound)

func _on_ui_tab_changed(tab):
	AudioManager.new_sound(clickSound)

func _on_ui_value_changed(value):
	AudioManager.new_sound(clickSound)
