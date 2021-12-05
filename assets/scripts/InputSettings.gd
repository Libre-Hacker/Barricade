extends Tabs

func _ready() -> void:
	load_settings()

func load_settings():
	var count = 0
	for button in get_node("ScrollContainer/Panel/VBoxContainer").get_children():
		button.get_children()
