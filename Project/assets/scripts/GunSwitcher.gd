extends Spatial

var currentWeaponIndex : int = 0
var numberOfWeapons : int

func _ready():
	numberOfWeapons = get_child_count()
	switchWeapon(0) # Switch to the first weapon in the GunBelt or all weapons will be active at game start.

func _unhandled_input(event):
	# Use +/- 1 to increment the current weapon when using scroll wheel.
	if(event.is_action_pressed("next_weapon")):
		switchWeapon(1) 
		get_tree().get_root().set_input_as_handled()
	elif(event.is_action_pressed("previous_weapon")):
		switchWeapon(-1)
		get_tree().get_root().set_input_as_handled()


func switchWeapon(increment : int):
	# Check if the increment needs to wrap to the start or end of the weapon list.
	if(currentWeaponIndex + increment > numberOfWeapons - 1): # Minus numberOfWeapons by 1 because currentWeaponIndex starts at 0.
		currentWeaponIndex = 0
	elif(currentWeaponIndex + increment < 0):
		currentWeaponIndex = numberOfWeapons - 1 # Minus numberOfWeapons by 1 because currentWeaponIndex starts at 0.
	else:
		currentWeaponIndex += increment
	
	var newWeaponIndex : int
	var yieldTime : float
	# Loop through all children, find and equip the selected weapon. Unequip all others.
	for index in get_child_count():
		var iteratedNode = get_child(index)
		if(index == currentWeaponIndex):
			newWeaponIndex = index
			continue
		else:
			if(iteratedNode.equipped == true):
				yieldTime = iteratedNode.animationPlayer.current_animation_length
			unEquipCurrentWeapon(iteratedNode)
	yield(get_tree().create_timer(yieldTime), "timeout")
	equipNewWeapon(get_child(newWeaponIndex))

# Prepare and unequip the current weapon.
func unEquipCurrentWeapon(oldWeapon : Node):
	if(oldWeapon.isReloading):
		oldWeapon.isReloading = false
		oldWeapon.animationPlayer.seek(0)
	if(oldWeapon.equipped == true):
		oldWeapon.animationPlayer.stop()
		oldWeapon.animationPlayer.play("unequip")
	else:
		oldWeapon.animationPlayer.seek(0)
		oldWeapon.animationPlayer.stop()
	oldWeapon.equipped = false
	oldWeapon.visible = false
	oldWeapon.set_process_unhandled_input(false)
	oldWeapon.set_block_signals(true)
	oldWeapon.set_process(false)

# Prepare and equip the new weapon.
func equipNewWeapon(newWeapon : Node):
	newWeapon.set_process(true)
	newWeapon.animationPlayer.stop()
	newWeapon.animationPlayer.play("equip")
	newWeapon.visible = true
	newWeapon.set_process_unhandled_input(true)
	newWeapon.set_block_signals(false)
	newWeapon.updateUI()

