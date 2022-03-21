extends RigidBody
# Handles state of prop, we do not use a hit box to detect attacks because most
# props will have unique collision boxes, so the rigid body captures the attacks
# and forwards them to the health node.

export (String) var realName = "Prop" # The name of the prop, for UI use.
export (float, 1) var followSpeed : float = 7.5 # The speed the prop moves while held.
export (float, 1) var rotationSpeed = 1.0 # The speed the prop can rotate.

var nodeToFollow : Node # Node the prop follows while picked up.
var isNailed : bool = false

signal damage_taken
signal repair_received
signal dropped

func _physics_process(_delta):
	followPoint()

# Sets class variables to enable pickup. 
# Called from outside class.
func pickup(assignedNode, player):
	if(is_picked_up() == false):
		set_collision_mask_bit(3, false) # Change collision mask so this won't collide while held.
		nodeToFollow = assignedNode
		add_collision_exception_with(player)
	else:
		print("Prop already in use.")

# Resets class variables to defaults.
# Called from outside class.
func drop():
	set_collision_mask_bit(3, true) # Change collision mask so this won't collide while held.
	if(is_picked_up()):
		remove_collision_exception_with(get_collision_exceptions()[0])
	nodeToFollow = null

# Moves this object to the nodeToFollow variable.
func followPoint():
	if(is_picked_up()):
		var moveDistance = (nodeToFollow.global_transform.origin - transform.origin)
		linear_velocity = moveDistance * followSpeed # Use physics to detect collisions.

# Rotates this object relative to the nodeToFollow.
func mouse_rotate(mouseMovement):
	var x = -nodeToFollow.global_transform.basis.x * mouseMovement.z
	var y = nodeToFollow.global_transform.basis.y * mouseMovement.x
	var z = (x + y).normalized()
	add_torque(z * (rotationSpeed * 10)) # "10" is the default multiplier.

# Changes the prop to a static body, drops the prop if it was carried.
func nail():
	if(is_picked_up()):
		emit_signal("dropped") # Connected via script to Player's Interaction node.
	else:
		drop()
	mode = 1
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	isNailed = true

# Returns the prop to a rigid body.
func unnail():
	mode = 0
	isNailed = false

# Returns true if the object is nailed.
func is_repairable():
	if(isNailed == true):
		return true
	else:
		return false

# Returns true if nodeToFollow is not null.
func is_picked_up():
	if(nodeToFollow == null):
		return false
	else:
		return true
