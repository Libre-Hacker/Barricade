extends Spatial

var currentWeaponIndex : int = 0 # Currently equipped weapon. Default 0.
var switchInProgress = false # Prevents switching too multiple times.
onready var numberOfWeapons : int = get_child_count() 

func _ready():
	# Switch to the first weapon in the GunBelt or all weapons will be active 
	# at game start.
	switchWeapons() 

func _unhandled_input(event):
	# Use +/- 1 to increment the current weapon when using scroll wheel.
	if(event.is_action_pressed("next_weapon")):
		changeWeaponIndex(1) 
		get_tree().get_root().set_input_as_handled()
	elif(event.is_action_pressed("previous_weapon")):
		changeWeaponIndex(-1)
		get_tree().get_root().set_input_as_handled()

# Modifies the current weapon index based on player mouse wheel input.
func changeWeaponIndex(increment : int):
	if(switchInProgress == true):
		return
	switchInProgress = true
	# Check if the increment needs to wrap to the start or end of the weapon list.
	if(currentWeaponIndex + increment > numberOfWeapons - 1): # Minus numberOfWeapons by 1 because currentWeaponIndex starts at 0.
		currentWeaponIndex = 0
	elif(currentWeaponIndex + increment < 0):
		currentWeaponIndex = numberOfWeapons - 1 # Minus numberOfWeapons by 1 because currentWeaponIndex starts at 0.
	else:
		currentWeaponIndex += increment
	
	switchWeapons()


func switchWeapons():

	# Loop through all children, unequip any equipped weaons. Equip the new weapon.
	for index in get_child_count():
		var iteratedNode = get_child(index)
		if(iteratedNode.equipped == true):
			yield(iteratedNode._unequip(), "completed")

	yield(get_child(currentWeaponIndex)._equip(), "completed")
	switchInProgress = false
