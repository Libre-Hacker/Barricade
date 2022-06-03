extends Spatial
# Controller class for the Hammer, controls input, and enabling/disabling the weapon.

var equipped = true

onready var repairNode = get_node("Repair")
onready var nailNode = get_node("Nail")
onready var animationPlayer = get_node("AnimationPlayer")
onready var infoGatherNode = get_node("InfoGather")
export (Resource) var addAmmoSound

signal hammer_equipped

func _ready():
	connect("hammer_equipped", find_parent("FPSPlayer").get_node("HUD/TutorialUI"), "toggle_hammer_controls")
	connect("hammer_equipped", find_parent("FPSPlayer").get_node("HUD/Crosshairs"), "on_hammer_equipped")
# Using process for all input, makes it easier to enable/disable on switching and since only one
# weapon is active at a time this shouldn't have a big impact on performance.
func _process(_delta):
	if(GameManager.isPaused):
		return
	if(Input.is_action_pressed("primary_fire") and nailNode.cooldownTimer.is_stopped()):
		repairNode.swing()
		get_tree().get_root().set_input_as_handled()
	if(repairNode.cooldownTimer.is_stopped()):
		if(Input.is_action_just_pressed("alt_fire")):
			nailNode.nail()
			get_tree().get_root().set_input_as_handled()
		if(Input.is_action_just_pressed("reload")):
			nailNode.remove_nail()
			get_tree().get_root().set_input_as_handled()

func _physics_process(_delta):
	if(GameManager.isPaused):
		return
	infoGatherNode.gather_prop_info()

func equip():
	show()
	set_physics_process(true)
	animationPlayer.play("equip")
	emit_signal("hammer_equipped")
	yield(animationPlayer, "animation_finished")
	set_process(true)
	infoGatherNode.enabled = true
	nailNode.update_ui()


func unequip():
	infoGatherNode.enabled = false
	set_process(false)
	animationPlayer.play("unequip")
	emit_signal("hammer_equipped")
	yield(animationPlayer, "animation_finished")
	set_physics_process(false)
	hide()

# Used by external sources to add ammo to this weapon.
func add_ammo(primaryAmmo = 0, secondaryAmmo = 0):
	nailNode.add_ammo(primaryAmmo)
	get_node("AudioManager").new_3d_sound(addAmmoSound)


func has_max_ammo():
	if(nailNode.ammo >= nailNode.maxAmmo):
		return true
	else:
		return false
