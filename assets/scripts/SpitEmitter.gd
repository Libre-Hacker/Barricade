extends AreaExtended

# Keeps track of any hitboxes inside the detection area.
# Signals the AI controller if priority targets are available.
func _on_area_entered(area):
	areaCount.append(area)

# Removes any hitboxes leaving the detection area.
# Signals the AI controller if no targets are available.
func _on_area_exited(area):
	areaCount.erase(area)
