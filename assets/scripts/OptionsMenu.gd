extends CanvasLayer

signal level_changed
var unsavedChanges = false

func _on_Back_button_down():
	if(unsavedChanges):
		get_node("Popup").popup()
	else:
		emit_signal("level_changed", "PreviousLevel")

func _on_Popup_confirmed():
	Settings.apply_settings()
	emit_signal("level_changed", "PreviousLevel")

func _on_setting_changed():
	unsavedChanges = true

func _on_ConfirmChanges_button_up():
	Settings.save_settings()
	unsavedChanges = false

func _on_ResetToDefault_button_up():
	Settings.load_settings(true)
	get_tree().call_group("setting_control", "load_settings")
