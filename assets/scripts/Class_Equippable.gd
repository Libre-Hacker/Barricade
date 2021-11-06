extends Spatial
class_name Equippable

export var startDisabled = false
var equipped = true

func equip():
	set_process(true)
	visible = true
	set_process_unhandled_input(true)
	set_block_signals(false)
	equipped = true


func unequip():
	visible = false
	set_process_unhandled_input(false)
	set_block_signals(true)
	set_process(false)
	equipped = false

