extends Spatial
# Manages weapons equipped weapons, and swiching between them.

var currentWeaponIndex : int = 0 # Currently equipped weapon. Default 0.
var switchInProgress = false # Prevents switching multiple times.
var enabled = true # Is switching enabled.

signal switch_complete

func _ready():
	for child in get_child_count():
		get_child(child).hide()
		get_child(child).set_process(false)
	switch_weapons() # Switch to weapon 0 or all weapons will be active at game start.


func _unhandled_input(event):
	if(GameManager.isPaused): # Prevents input while the game is paused.
		return
	# Use +/- 1 to increment the current weapon when using scroll wheel.
	if(event.is_action_pressed("next_weapon")):
		increment_weapon_index(1) 
		get_tree().get_root().set_input_as_handled()
	elif(event.is_action_pressed("previous_weapon")):
		increment_weapon_index(-1)
		get_tree().get_root().set_input_as_handled()

# Modifies the current weapon index based on player mouse wheel input.
func increment_weapon_index(increment : int):
	# Check if the increment needs to wrap to the start or end of the weapon list.
	if(currentWeaponIndex + increment > get_child_count() - 1): # Minus child count by 1 because currentWeaponIndex starts at 0.
		set_current_weapon_index(0)
	elif(currentWeaponIndex + increment < 0):
		set_current_weapon_index(get_child_count() - 1) # Minus child count by 1 because currentWeaponIndex starts at 0.
	else:
		set_current_weapon_index(currentWeaponIndex + increment)

# Sets the current weapon index.
func set_current_weapon_index(value : int):
	if(enabled != true or switchInProgress == true or currentWeaponIndex == value):
		return
	clamp(value, 0, get_child_count() - 1)
	currentWeaponIndex = value
	switch_weapons()

# Unequips active weapon, and equips the weapon at the current index.
func switch_weapons(index = -1):
	switchInProgress = true
	# Loop through all children, unequip any equipped weaons. Equip the new weapon.
	for weapon in get_child_count():
		var iteratedNode = get_child(weapon)
		if(iteratedNode.is_processing()):
			yield(iteratedNode.unequip(), "completed")
	
	if(index != -1 and index != currentWeaponIndex):
		currentWeaponIndex = index

	yield(get_child(currentWeaponIndex).equip(), "completed")
	switchInProgress = false
	emit_signal("switch_complete")

# Adds a new weapon to the gun belt.
func add_weapon(newWeapon):
	newWeapon.hide()
	newWeapon.set_process(false)
	add_child(newWeapon)
	if(switchInProgress):
		yield(self, "switch_complete")
		print("YEND")
	print("Switching")
	set_current_weapon_index(newWeapon.get_index())

# Enables weapons when not phased.
func enable_weapons():
	get_child(currentWeaponIndex).set_process(true)
	enabled = true

# Disables current weapon, and weapon switching.
func disable_weapons():
	if(switchInProgress):
		yield(switch_weapons(), "completed")
	get_child(currentWeaponIndex).set_process(false)
	enabled = false
