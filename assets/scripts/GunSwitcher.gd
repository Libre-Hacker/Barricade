extends Spatial

var currentWeaponIndex : int = 0
var numberOfWeapons : int
var currentWeapon : Node

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
	
	
	# Loop through all children, find and equip the selected weapon. Unequip all others.
	for index in get_child_count():
		var iteratedNode = get_child(index)
		print(index)
		if(index == currentWeaponIndex):
			equipNewWeapon(iteratedNode)
		elif(iteratedNode.equipped == true):
			unEquipCurrentWeapon(iteratedNode)

# Prepare and unequip the current weapon.
func unEquipCurrentWeapon(oldWeapon : Node):
	if(oldWeapon.isReloading):
		oldWeapon.isReloading = false
		oldWeapon.animationPlayer.seek(0,true)
	oldWeapon.animationPlayer.stop()
	oldWeapon.animationPlayer.play("unequip")
	oldWeapon.equipped = false
	oldWeapon.set_process_input(false)
	oldWeapon.set_process(false)
	print(oldWeapon.name, " is unequipping")

# Prepare and equip the new weapon.
func equipNewWeapon(newWeapon : Node):
	newWeapon.set_process(true)
	newWeapon.animationPlayer.stop()
	newWeapon.animationPlayer.play("equip")
	newWeapon.visible = true
	newWeapon.set_process_input(true)
	newWeapon.updateUI()
	currentWeapon = newWeapon

