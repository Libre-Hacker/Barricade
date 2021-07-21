extends Spatial

var currentWeapon : int = 0
var numberOfWeapons : int

func _ready():
	numberOfWeapons = get_child_count()
	switchWeapon(0) # Seitch to the first weapon in the GunBelt or all weapons will be active at game start.

func _input(event):
	# Use +/- 1 to increment the current weapon when using scroll wheel.
	if(Input.is_action_just_pressed("next_weapon")):
		switchWeapon(1) 
	elif(Input.is_action_just_pressed("previous_weapon")):
		switchWeapon(-1)

# 
func switchWeapon(increment : int):
	# Check if the increment needs to wrap to the start or end of the weapon list.
	if(currentWeapon + increment > numberOfWeapons - 1): # Minus numberOfWeapons by 1 because currentWeapon starts at 0.
		currentWeapon = 0
	elif(currentWeapon + increment < 0):
		currentWeapon = numberOfWeapons - 1 # Minus numberOfWeapons by 1 because currentWeapon starts at 0.
	else:
		currentWeapon += increment
	
	# Loop through all children, find and equip the selected weapon. Unequip all others.
	for index in get_child_count():
		var iteratedNode = get_child(index)
		if(index == currentWeapon):
			equipNewWeapon(iteratedNode)
		else:
			unEquipCurrentWeapon(iteratedNode)

# Prepare and unequip the current weapon.
func unEquipCurrentWeapon(currentWeapon : Node):
	if(currentWeapon.isReloading):
		currentWeapon.isReloading = false
		currentWeapon.animationPlayer.seek(0,true)
	currentWeapon.animationPlayer.stop()
	currentWeapon.animationPlayer.play("unequip")
	currentWeapon.equipped = false
	currentWeapon.set_process_input(false)
	currentWeapon.set_process(false)

# Prepare and equip the new weapon.
func equipNewWeapon(newWeapon : Node):
	newWeapon.set_process(true)
	newWeapon.animationPlayer.stop()
	newWeapon.animationPlayer.play("equip")
	newWeapon.visible = true
	newWeapon.set_process_input(true)

