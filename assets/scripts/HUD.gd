extends Control

const menuOpened = preload("res://assets/resources/menu_opened.tres")

func _process(_delta):
	if(menuOpened.Value):
		self.hide()
	else:
		self.show()
