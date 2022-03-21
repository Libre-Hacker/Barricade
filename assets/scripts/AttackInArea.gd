extends AreaExtended
# This class singals the AI controller when targets are available, and receives
# signals to execute the main behaviour loop for attacking. Attacking works by
# looping through all the overlapping bodies, and pointing a cone of raycasts at
# each body to determine if a line of sight can be established. Once a target is
# found deal damage to it.

export (float, 0, 100) var attackDamage = 10 # Damage each attack deals.
export (Resource) var missSound
export (Resource) var hitSound
export (Resource) var attackSound

var target = null # Keep target variable for optimization.

signal play_animation(animationName)
signal targets_available # Emit's when viable targets are in range.
signal targets_unavailable # Emit's when no targets are within area.
signal play_3dsound(stream)

onready var lineOfSight = get_node("LineOfSight")
onready var attackCDTimer = get_node("AttackCDTimer")

# Main behaviour loop.
func attack_behaviour():
	find_target()
	attempt_attack()

# Establishes a target by checking if there is line of sight to each object
# in the area.
func find_target():
	if(target != null): # Saves execution if target still exists.
		return
	for object in areaCount:
		if(lineOfSight.has_line_of_sight(object)):
			target = object
		else:
			emit_signal("targets_unavailable")

# Starts the cooldown timer and singals for animation player to play attack
func attempt_attack():
	if(target == null):
		return
	if(attackCDTimer.is_stopped()):
		emit_signal("play_animation", "attack")
		attackCDTimer.start()

# Damages the target, called by the AnimationPlayer
func damage_target():
	emit_signal("play_3dsound", attackSound)
	if(target == null):
		emit_signal("play_3dsound", missSound)
		return
	emit_signal("play_3dsound", hitSound)
	target.damage(attackDamage, null)

# A priority target is a player or a nailed prop.
func is_priority_target(hitbox):
	if(hitbox.is_in_group("Players") or hitbox.is_in_group("Props") and hitbox.get_parent().isNailed):
		return true
	else:
		return false

# Keeps track of any hitboxes inside the detection area.
# Signals the AI controller if priority targets are available.
func _on_area_entered(area):
	areaCount.append(area)
	if(is_priority_target(area)):
		emit_signal("targets_available")

# Removes any hitboxes leaving the detection area.
# Signals the AI controller if no targets are available.
func _on_area_exited(area):
	areaCount.erase(area)
	if(area == target):
		target = null
	if(areaCount.empty()):
		if(attackCDTimer.is_stopped() == false):
			yield(attackCDTimer, "timeout")
		emit_signal("targets_unavailable")
