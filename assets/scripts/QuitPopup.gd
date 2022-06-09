extends Popup
# Handles signals from children to confirm a quit request, or cancel it.

# Cancel the quit request.
func _on_Cancel_button_up():
	self.hide()

# Quit the application.
func _on_Confirm_button_up():
	get_tree().quit()

