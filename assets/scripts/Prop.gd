extends RigidBody

var nodeToFollow : Node
var isPickedUp : bool = false
var isNailed : bool = false
export (float, 1, 20, 0.1) var followSpeed : float = 7.5
export (float, 1,1000) var health : float
export (float, 1,1000) var maxHealth : float

func _physics_process(_delta):
	followPoint()

# Sets class variables to enable pickup. 
# Called from outside class.
func pickup(assignedNode):
	if(isPickedUp == false):
		set_collision_mask_bit(1, false) # Change collision mask so this can't be detected by other rays.
		nodeToFollow = assignedNode
		isPickedUp = true
	else:
		print("Prop already in use.")

# Resets class variables to defaults.
# Called from outside class.
func drop():
	set_collision_mask_bit(1, true)
	nodeToFollow = null
	isPickedUp = false

# Moves this object to the nodeToFollow variable.
func followPoint():
	if(isPickedUp):
		var moveDistance = (nodeToFollow.global_transform.origin - transform.origin)
		linear_velocity = moveDistance * followSpeed # Use physics to detect collisions.

# Rotates this object relative to the nodeToFollow.
func rotateProp(mouseMovement):
	var x = deg2rad(mouseMovement.y)
	var y = deg2rad(mouseMovement.x)
	global_rotate(nodeToFollow.transform.basis.y, y)
	rotate(nodeToFollow.global_transform.basis.x, x)

# Flips damage value to negative.
func damage(value : float):
	if(health - value <= 0):
		print(name, " is destroyed.")
		self.queue_free()
	else:
		health -= value
		print(name, " health = ", health)

func nail():
	drop()
	mode = 1
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	isNailed = true

func unnail():
	mode = 0
	isNailed = false

func repair(value):
	if(health + value > maxHealth):
		health = maxHealth
	else:
		health += value
	print(name, " health = ", health)

func is_repairable():
	if(isNailed == true and health < maxHealth):
		return true
	else:
		return false

