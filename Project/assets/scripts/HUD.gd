extends Control
# Shows and hides the Hud when the game is paused.

func _process(_delta):
	if(GameManager.isPaused or is_network_master() == false):
		self.hide()
	else:
		self.show()
