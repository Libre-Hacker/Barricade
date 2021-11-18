extends Area

# This class singals the AI controller when targets are available, and receives
# signals to execute the main behaviour loop for attacking. Attacking works by
# looping through all the overlapping bodies, and pointing a cone of raycasts at
# each body to determine if a line of sight can be established. Once a target is
# found deal damage to it.

export (float, 0, 100) var attackDamage = 10 # Damage each attack deals.

var attacking = false # Behaviour state bool, when true executes the main loop.
var target = null # Keep target variable for optimization.
var bodyCount = [] # Keep track of overlapping bodies with our own variable.
# get_overlapping_boddies() is VERY unreliable with signals.

signal play_animation(animationName)
signal targets_available # Emit's when viable targets are in range.
signal targets_unavilable # Emit's when no targets are within area.

onready var lineOfSight = get_node("LineOfSight")

func _physics_process(_delta):
	if(attacking):
		attack()

func attack():
	# Must reset the state bool every frame. AI Controller will send a signal
	# each frame it want's to run this behaviour. Must be reset first, so we don't
	# return from this function without resetting it.
	attacking = false
	find_target()
	attempt_attack()

# Establishes a target by checking if there is line of sight to each object
# in the area.
func find_target():
	if(target != null): # Saves execution if target still exists.
		return
	for object in bodyCount:
		if(lineOfSight.has_line_of_sight(object)):
			target = object
		else:
			emit_signal("targets_unavilable")

# Starts the cooldown timer and singals for animation player to play attack
func attempt_attack():
	if(get_node("AttackTimer").is_stopped()):
		emit_signal("play_animation", "attack")
		get_node("AttackTimer").start()

# Damages the target, called by the AnimationPlayer
func damage_target():
	if(target == null):
		return
	target.damage(null, attackDamage)

# A priority target is a player or a nailed prop.
func is_priority_target(body):
	if(body.is_in_group("Players") or body.is_in_group("Props") and body.isNailed):
		return true
	else:
		return false

# Signals the AI controller that a primary target is within range, updates the
# bodyCount array.
func _on_PrimaryAttack_body_entered(body):
	bodyCount.append(body)
	if(is_priority_target(body)):
		emit_signal("targets_available")

# Updates the body count array, and signals the AI controller if the bodyCount
# array is empty.
func _on_PrimaryAttack_body_exited(body):
	bodyCount.erase(body)
	if(body == target):
		target = null
	if(bodyCount.size() < 1):
		emit_signal("targets_unavilable")

func _on_AIController_attack():
	attacking = true
