extends KinematicBody

# This class handles the seeking behaviour for the zombie AI. The kinematic body
# must remain at the top of the tree, as it will only move and rotate it's children.
# For now, health values are handled on this class for the same reason. This may
# be a good idea to change down the road.


export (float, 0,200) var pushForce = 2 # Amount of force applied to pushed rigidbodies.
export (float, 0, 10) var moveSpeed = 4 # Movement velocity.
export (float, 0, 1) var slowedThreshold = 0.01 # Velocity below threshold is considered obstructed.
export (float, 0, 10) var turnRate = 6 # Turning velocity.
export (float, 0, 90) var maxSlope = 45 # Max incline degrees this entity can climb.

var seeking = false # AI State, while true executes the state behaviour loop.

signal obstructed(value)


onready var navigator = get_node("Navigator")

func _physics_process(delta):
	if(seeking):
		seek_behaviour(delta)

# Main behaviour loop
func seek_behaviour(delta):
	# Must reset the state bool every frame. AI Controller will send a signal
	# each frame it want's to run this behaviour. Must be reset first, so we don't
	# return from this function without resetting it.
	seeking = false
	var direction = navigator.get_path_direction()
	# Prevents zombie from snap rotating when the path updates.
	if(direction == Vector3.ZERO):
		return

	look_at_target(direction, delta)
	move(direction)
	push_rigid_bodies()
	
	

# Rotates towards the travel direction over time.
func look_at_target(direction, delta):
	rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * turnRate)

# Moves this object, to the desired path point.
func move(direction):
	# Track the distance before and after moving to see if this object is stuck.
	var currentPos = transform.origin
# warning-ignore:return_value_discarded
	move_and_slide(direction.normalized() * moveSpeed, Vector3.UP, true, 3, deg2rad(maxSlope), false)
	var newPos = transform.origin
	var distanceMoved = currentPos.distance_to(newPos)
	is_obstructed(distanceMoved)

# Emits signals to the AI Controller when this object is stuck/unstuck.
func is_obstructed(distanceMoved):
	if(distanceMoved > slowedThreshold):
		emit_signal("obstructed", false)
	else:
		emit_signal("obstructed", true)

# Pushes any rigid body this object collides with in a realistic way.
func push_rigid_bodies():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if(collision.collider.is_in_group("Props")):
			collision.collider.apply_central_impulse(-collision.normal * pushForce)



# Signal from the AIController to start executing the behaviour loop.
func _on_AIController_seek():
	seeking = true
