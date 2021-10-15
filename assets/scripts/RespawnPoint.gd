extends Position3D

onready var spawnArea = get_node("Area")

export var isOpen = true

func select_spawn():
	if(isOpen):
		isOpen = false
		return true
	else:
		return false

func _on_Area_body_exited(body):
	if(spawnArea.get_overlapping_bodies().size() < 1):
		isOpen = true
	else:
		isOpen = false
