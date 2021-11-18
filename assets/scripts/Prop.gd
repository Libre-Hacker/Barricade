extends RigidBody

var nodeToFollow : Node
var isPickedUp : bool = false
var isNailed : bool = false
var interactingPlayer = null
export (String) var realName = "Prop"
export (float, 1, 20, 0.1) var followSpeed : float = 7.5
export (float, 1,1000) var health : float
export (float, 1,1000) var maxHealth : float

signal health_changed
signal dropped

func _physics_process(_delta):
	followPoint()

# Sets class variables to enable pickup. 
# Called from outside class.
func pickup(assignedNode, player):
	if(isPickedUp == false):
		set_collision_mask_bit(3, false) # Change collision mask so this won't collide while held.
		nodeToFollow = assignedNode
		isPickedUp = true
		interactingPlayer = player
		add_collision_exception_with(interactingPlayer)
	else:
		print("Prop already in use.")

# Resets class variables to defaults.
# Called from outside class.
func drop():
	emit_signal("dropped")
	set_collision_mask_bit(3, true) # Change collision mask so this won't collide while held.
	nodeToFollow = null
	isPickedUp = false
	remove_collision_exception_with(interactingPlayer)
	interactingPlayer = null

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
func damage(_attacker = null, value = 0.0):
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

func repair(entity, value):
	if(health >= maxHealth):
		return
	if(health + value > maxHealth):
		health = maxHealth
	else:
		health += value
	print(name, " health = ", health)
	emit_signal("health_changed", entity, value)

func is_repairable():
	if(isNailed == true and health < maxHealth):
		return true
	else:
		return false

func kill():
	damage(null, health)
