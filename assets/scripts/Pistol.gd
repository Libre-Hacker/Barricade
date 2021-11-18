extends Equippable

onready var primaryFireNode = get_node("PrimaryFire")
onready var animationPlayer = get_node("AnimationPlayer")

func _ready():
	if(startDisabled):
		visible = false
		_unequip()

func _equip():
	.equip()
	animationPlayer.play("equip")
	yield(animationPlayer, "animation_finished")
	enable()

func _unequip():
	disable()
	animationPlayer.play("unequip")
	yield(animationPlayer, "animation_finished")
	.unequip()

func add_ammo(primaryValue = 0, _alternativeValue = 0):
	if(primaryFireNode.is_reserve_full() == false):
		primaryFireNode.add_reserve_ammo(primaryValue)

func disable():
	if(primaryFireNode.isReloading):
		primaryFireNode.isReloading = false
	primaryFireNode.set_process_unhandled_input(false)
	primaryFireNode.set_process(false)

func enable():
	primaryFireNode.set_process_unhandled_input(true)
	primaryFireNode.set_process(true)
	primaryFireNode.update_ui()
