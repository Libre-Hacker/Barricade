extends Spatial
class_name Equippable

export var startDisabled = false
var equipped = true

func equip():
	set_process(true)
	show()
	set_process_unhandled_input(true)
	set_physics_process(true)
	equipped = true


func unequip():
	hide()
	set_process_unhandled_input(false)
	set_process(false)
	set_physics_process(false)
	equipped = false

