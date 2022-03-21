extends Control
# Shows and hides the Hud when the game is paused.

func _process(_delta):
	if(GameManager.isPaused):
		self.hide()
	else:
		self.show()
