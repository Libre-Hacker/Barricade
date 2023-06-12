extends Spatial
# Controller class for the Hammer, controls input, and enabling/disabling the weapon.

export (Resource) var addAmmoSound

var enabled = true

onready var primaryFire = get_node("PrimaryFire")
onready var altFire = get_node("AltFire")
onready var animationPlayer = get_node("AnimationPlayer")
onready var audioManager = get_node("AudioManager")
onready var hud = get_node("HUD")
onready var player = GameManager.playerManager.PLAYER

signal equipped

func _ready():
	connect("equipped", player.get_node("HUD/TutorialUI"), "toggle_hammer_controls")
	altFire.update_ui()


func _process(_delta):
	if(GameManager.isPaused):
		get_node("HUD").hide()
		return
	else:
		get_node("HUD").show()
	
	if(!enabled):
		primaryFire.stop_primary_fire()
	if(Input.is_action_just_released("primary_fire")):
		primaryFire.stop_primary_fire()
		get_tree().get_root().set_input_as_handled()
	if(Input.is_action_pressed("primary_fire") and enabled):
		primaryFire.primary_fire()
		get_tree().get_root().set_input_as_handled()
	if(Input.is_action_just_pressed("alt_fire") and enabled):
		altFire.nail()
		get_tree().get_root().set_input_as_handled()
	if(Input.is_action_just_pressed("reload") and enabled):
		altFire.remove_nail()
		get_tree().get_root().set_input_as_handled()


func equip():
	if(is_network_master()):
		show()
		hud.show()
	animationPlayer.play("equip")
	emit_signal("equipped")
	yield(animationPlayer, "animation_finished")
	set_process(true)


func unequip():
	primaryFire.stop_primary_fire()
	set_process(false)
	animationPlayer.play("unequip")
	yield(animationPlayer, "animation_finished")
	hide()
	hud.hide()

# Used by external sources to add ammo to this weapon.
func add_ammo(primaryAmmo = 0, secondaryAmmo = 0):
	altFire.add_ammo(primaryAmmo)
	get_node("AudioManager").new_sound(addAmmoSound)


func has_max_ammo():
	if(altFire.ammo >= altFire.maxAmmo):
		return true
	else:
		return false
