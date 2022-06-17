extends Spatial
# Controller class for the Hammer, controls input, and enabling/disabling the weapon.

export (Resource) var addAmmoSound


onready var primaryFire = get_node("PrimaryFire")
onready var altFire = get_node("AltFire")
onready var animationPlayer = get_node("AnimationPlayer")
onready var audioManager = get_node("AudioManager")
onready var hud = get_node("HUD")

signal equipped

func _ready():
	connect("equipped", find_parent("FPSPlayer").get_node("HUD/TutorialUI"), "toggle_hammer_controls")
	altFire.update_ui()


func _process(_delta):
	if(GameManager.isPaused):
		return
	if(primaryFire.cycleTimer.is_stopped() == false or altFire.cycleTimer.is_stopped() == false):
		return
	if(Input.is_action_pressed("primary_fire")):
		primaryFire.primary_fire()
		get_tree().get_root().set_input_as_handled()
	if(Input.is_action_just_pressed("alt_fire")):
		altFire.nail()
		get_tree().get_root().set_input_as_handled()
	if(Input.is_action_just_pressed("reload")):
		altFire.remove_nail()
		get_tree().get_root().set_input_as_handled()


func equip():
	show()
	hud.show()
	animationPlayer.play("equip")
	emit_signal("equipped")
	yield(animationPlayer, "animation_finished")
	set_process(true)


func unequip():
	set_process(false)
	animationPlayer.play("unequip")
	yield(animationPlayer, "animation_finished")
	hide()
	hud.hide()

# Used by external sources to add ammo to this weapon.
func add_ammo(primaryAmmo = 0, secondaryAmmo = 0):
	altFire.add_ammo(primaryAmmo)
	get_node("AudioManager").new_3d_sound(addAmmoSound)


func has_max_ammo():
	if(altFire.ammo >= altFire.maxAmmo):
		return true
	else:
		return false
