extends Equippable
# Manager class for the Hammer, handles connections and equipping/unequipping.

onready var repairNode = get_node("Repair")
onready var nailNode = get_node("Nail")
onready var animationPlayer = get_node("AnimationPlayer")

# Override equip code for each input function
func _equip():
	.equip()
	animationPlayer.play("equip")
	yield(animationPlayer, "animation_finished")
	repairNode.set_process(true)
	repairNode.set_process_unhandled_input(true)
	nailNode.set_process(true)
	nailNode.set_process_unhandled_input(true)
	nailNode.update_ui()

# Override unequip code for each input function
func _unequip():
	repairNode.set_process_unhandled_input(false)
	repairNode.set_process(false)
	nailNode.set_process_unhandled_input(false)
	nailNode.set_process(false)
	animationPlayer.play("unequip")
	yield(animationPlayer, "animation_finished")
	.unequip()
