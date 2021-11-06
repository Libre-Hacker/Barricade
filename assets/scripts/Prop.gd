extends RigidBody

var nodeToFollow : Node
var isPickedUp : bool = false
var isNailed : bool = false
export (String) var realName = "Prop"
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
		set_collision_mask_bit(5, false) # Change collision mask so this won't collide while held.
		set_collision_mask_bit(3, false) # Change collision mask so this won't collide while held.
		nodeToFollow = assignedNode
		isPickedUp = true
	else:
		print("Prop already in use.")

# Resets class variables to defaults.
# Called from outside class.
func drop():
	set_collision_mask_bit(1, true)
	set_collision_mask_bit(5, true)
	set_collision_mask_bit(3, true) 
	nodeToFollow = null
	isPickedUp = false

# Moves this object to the nodeToFollow variable.
func followPoint():
	if(isPickedUp):
		var moveDistance = (nodeToFollow.global_transform.origin - transform.origin)
		linear_velocity = moveDistance * followSpeed # Use physics to detect collisions.

# Rotates this object relative to the nodeToFollow.
func rotate_prop(mouseMovement):
	var x = nodeToFollow.global_transform.basis.x.normalized() * mouseMovement.y * 10
	var y = nodeToFollow.global_transform.basis.y.normalized() * mouseMovement.x * 10
	add_torque(x)
	add_torque(y)

# Flips damage value to negative.
func damage(attacker = null, value = 0.0):
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

