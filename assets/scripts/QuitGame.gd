extends Button

func _on_Quit_button_down():
	get_node("VBoxContainer").visible = true

func _on_Confirm_button_down():
	get_tree().quit()

func _on_Cancel_button_down():
	get_node("VBoxContainer").visible = false
