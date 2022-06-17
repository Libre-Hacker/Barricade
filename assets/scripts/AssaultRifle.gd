extends Spatial

export (Resource) var addAmmoSound

signal equipped

onready var primaryFire = get_node("PrimaryFire")
onready var animationPlayer = get_node("AnimationPlayer")
onready var hud = get_node("HUD")


func _ready():
	connect("equipped", find_parent("FPSPlayer").get_node("HUD/TutorialUI"), "toggle_gun_controls")
	primaryFire.update_ui()


func _process(delta):
	if(GameManager.isPaused):
		return
	if(Input.is_action_just_pressed("reload")):
		primaryFire.startReload()
		get_tree().get_root().set_input_as_handled()
	if(Input.is_action_pressed("primary_fire")):
		primaryFire.primary_fire()
		get_tree().get_root().set_input_as_handled()


# Equips this weapon. If something changes here it probably needs to change in all equippables.
func equip():
	show()
	hud.show()
	animationPlayer.play("equip")
	emit_signal("equipped") # Tells the HUD to display gun controls.
	yield(animationPlayer, "animation_finished")
	set_process(true)


# Unequips this weapon. If something changes here it probably needs to change in all equippables.
func unequip():
	if(primaryFire.isReloading):
		primaryFire.isReloading = false
	set_process(false)
	animationPlayer.play("unequip")
	yield(animationPlayer, "animation_finished")
	hide()
	hud.hide()


# Used by external sources to add ammo to this weapon.
func add_ammo(primaryAmmo = 0, secondaryAmmo = 0):
	primaryFire.add_ammo(primaryAmmo)
	get_node("AudioManager").new_3d_sound(addAmmoSound)


func has_max_ammo():
	if(primaryFire.reserveAmmo >= primaryFire.maxReserveAmmo):
		return true
	else:
		return false
