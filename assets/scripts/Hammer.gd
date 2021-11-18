extends Equippable
# Manager class for the Hammer, handles connections and equipping/unequipping.

onready var repairNode = get_node("Repair")
onready var nailNode = get_node("Nail")
onready var animationPlayer = get_node("AnimationPlayer")
onready var infoGatherNode = get_node("InfoGather")

func _ready():
	if(startDisabled):
		visible = false
		_unequip()

# Override equip code for each input function
func _equip():
	.equip()
	animationPlayer.play("equip")
	yield(animationPlayer, "animation_finished")
	enable()

# Override unequip code for each input function
func _unequip():
	disable()
	animationPlayer.play("unequip")
	yield(animationPlayer, "animation_finished")
	.unequip()
	
func add_ammo(primaryValue = 0, _alternativeValue = 0):
	if(nailNode.is_ammo_full() == false):
		nailNode.add_ammo(primaryValue)

func disable():
	repairNode.set_process_unhandled_input(false)
	repairNode.set_process(false)
	nailNode.set_process_unhandled_input(false)
	nailNode.set_process(false)
	infoGatherNode.set_physics_process(false)
	infoGatherNode.update_ui(true)

func enable():
	repairNode.set_process_unhandled_input(true)
	repairNode.set_process(true)
	nailNode.set_process_unhandled_input(true)
	nailNode.set_process(true)
	nailNode.update_ui()
	infoGatherNode.set_physics_process(true)
	
