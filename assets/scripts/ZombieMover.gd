extends KinematicBody
# This class handles the seeking behaviour for the zombie AI. The kinematic body
# must remain at the top of the tree, as it will only move and rotate it's children.

export (float, 0,200) var pushForce = 2 # Amount of force applied to pushed rigidbodies.
export (float, 0, 10) var moveSpeed = 4 # Movement velocity.
export (float, 0, 1) var slowedThreshold = 0.01 # Velocity below threshold is considered obstructed.
export (float, 0, 10) var turnRate = 10 # Turning velocity.
export (float, 0, 90) var maxSlope = 45 # Max incline degrees this entity can climb.

signal obstructed
signal play_animation

onready var aiController = get_node("AIController")
onready var navigator = get_node("Navigator")
onready var primaryAttack = get_node("PrimaryAttack")

func _physics_process(delta):
	if(primaryAttack.target != null):
		look_at_target(primaryAttack.target.global_transform.origin, delta)
	elif(global_transform.origin.distance_to(navigator.player.transform.origin) < 3):
		look_at_target(navigator.player.transform.origin, delta)
	elif(navigator.has_path()):
		look_at_target(navigator.get_current_path_point(), delta)

# Main behaviour loop.
func seek_behaviour(delta):
	var direction = navigator.get_path_direction()
	move(direction)
	emit_signal("play_animation", "Walk")
	

# Rotates towards a target Vector3.
func look_at_target(target, delta):
	if(aiController.currentState == aiController.AI_STATE.DEAD):
		return
	var direction = target - global_transform.origin
	rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * turnRate)

# Moves this object in the direction of the next path point.
func move(direction):
	# Track the distance before and after moving to see if this object is stuck.
	var currentPos = transform.origin
	move_and_slide(direction.normalized() * moveSpeed, Vector3.UP, true, 3, deg2rad(maxSlope), false)
	var newPos = transform.origin
	var distanceMoved = currentPos.distance_to(newPos)
	is_obstructed(distanceMoved)
	push_rigid_bodies()

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


func disable_collisions():
	get_node("ColliderMain").disabled = true
