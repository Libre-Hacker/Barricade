extends Spatial
class_name Equippable

onready var animationPlayer = get_node("AnimationPlayer")

signal equipped



func _ready():
	connect("equipped", find_parent("FPSPlayer").get_node("HUD/TutorialUI"), "toggle_gun_controls")


func equip():
	show()
	get_node("HUD").show()
	primaryFireNode.update_ui()
	animationPlayer.play("equip")
	emit_signal("equipped") # Tells the HUD to display gun controls.
	yield(animationPlayer, "animation_finished")
	set_process(true)


func unequip():
	if(primaryFireNode.isReloading):
		primaryFireNode.isReloading = false
	set_process(false)
	animationPlayer.play("unequip")
	yield(animationPlayer, "animation_finished")
	hide()
	get_node("HUD").hide()
