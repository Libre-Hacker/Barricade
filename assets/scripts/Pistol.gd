extends Equippable

onready var primaryFireNode = get_node("PrimaryFire")
onready var animationPlayer = get_node("AnimationPlayer")

func _equip():
	.equip()
	animationPlayer.play("equip")
	yield(animationPlayer, "animation_finished")
	primaryFireNode.set_process(true)
	primaryFireNode.set_process_unhandled_input(true)

func _unequip():
	if(primaryFireNode.isReloading):
		primaryFireNode.isReloading = false
	primaryFireNode.set_process_unhandled_input(false)
	primaryFireNode.set_process(false)
	animationPlayer.play("unequip")
	yield(animationPlayer, "animation_finished")
	.unequip()

