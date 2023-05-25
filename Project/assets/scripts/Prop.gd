extends RigidBody
# Handles state of prop, we do not use a hit box to detect attacks because most
# props will have unique collision boxes, so the rigid body captures the attacks
# and forwards them to the health node.

export (String) var realName = "Prop" # The name of the prop, for UI use.
export (float) var followSpeed : float = 7.5 # The speed the prop moves while held.
export (float) var rotationAcceleration = 2 # The speed the prop can rotate.
export (float) var maxRotationSpeed = 20

var holdInPlace = false
var nodeToFollow : Node # Node the prop follows while picked up.
var isNailed : bool = false

var pickedUp = false
signal damage_taken
signal repair_received
signal dropped

onready var defaultAngularDamp = angular_damp

func _physics_process(_delta):
	followPoint()

func set_picked_up(value):
	pickedUp = value
	if(pickedUp):
		for material in get_node("Model").get_child(0).get_surface_material_count():
			get_node("Model").get_child(0).get_surface_material(material).flags_transparent = true
		set_collision_mask_bit(3, false) # Change collision mask so this won't collide while held.
		for players in GameManager.playerManager.get_children():
			add_collision_exception_with(players)
	else:
		for materials in get_node("Model").get_child(0).get_surface_material_count():
				get_node("Model").get_child(0).get_surface_material(materials).flags_transparent = false
		set_collision_mask_bit(3, true) # Change collision mask so this won't collide while held.
		for exception in get_collision_exceptions():
			remove_collision_exception_with(exception)

# Sets class variables to enable pickup. 
# Called from outside class.
func pickup(assignedNode, player):
	if(pickedUp == false):
		set_picked_up(true)
		nodeToFollow = assignedNode
		angular_damp = 10
		return true
	else:
		return false

# Resets class variables to defaults.
# Called from outside class.
func drop():
	nodeToFollow = null
	holdInPlace = false
	angular_damp = defaultAngularDamp
	if(get_node("OccupiedArea").bodyCount.size() > 0):
		yield(get_node("OccupiedArea"), "area_empty")
	set_picked_up(false)

# Moves this object to the nodeToFollow variable.
func followPoint():
	if(is_picked_up()):
		if(holdInPlace):
			linear_velocity = Vector3.ZERO
			angular_velocity = Vector3.ZERO
			lock_all_axis(true)
			return
		else:
			lock_all_axis(false)
		var moveDistance = (nodeToFollow.global_transform.origin - transform.origin) * followSpeed
		linear_velocity = moveDistance # Use physics to detect collisions.

# Rotates this object relative to the nodeToFollow.
func mouse_rotate(mouseMovement):
	var xRot = Vector3.ZERO
	var yRot = Vector3.ZERO
	if(holdInPlace):
		return
	if(mouseMovement.length() == 0):
		return

	# If the X and Y mouse input is greater than 0.15, only rotate the prop in the direction of the
	# greater input direction.
	if(abs(abs(mouseMovement.x) - abs(mouseMovement.y)) > 0.15):
		if(abs(mouseMovement.x) > abs(mouseMovement.y)):
			yRot = nodeToFollow.global_transform.basis.y * mouseMovement.x
		else:
			xRot = -nodeToFollow.global_transform.basis.x * mouseMovement.y
	else:
		yRot = nodeToFollow.global_transform.basis.y * mouseMovement.x
		xRot = -nodeToFollow.global_transform.basis.x * mouseMovement.y

	var rotDirection = (xRot + yRot) * rotationAcceleration

	if(angular_velocity.length() < maxRotationSpeed):
		angular_velocity += rotDirection


# Changes the prop to a static body, drops the prop if it was carried.
func nail():
	if(is_picked_up()):
		emit_signal("dropped") # Connected via script to Player's Interaction node.
	else:
		drop()

	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	lock_all_axis(true)
	isNailed = true


func lock_all_axis(value : bool):
	axis_lock_angular_x = value
	axis_lock_angular_y = value
	axis_lock_angular_z = value
	axis_lock_linear_x = value
	axis_lock_linear_y = value
	axis_lock_linear_z = value


# Returns the prop to a rigid body.
func unnail():
	lock_all_axis(false)
	isNailed = false
	sleeping = false

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
