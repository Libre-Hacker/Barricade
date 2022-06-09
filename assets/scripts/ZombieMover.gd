extends KinematicBody
# This class handles the seeking behaviour for the zombie AI. The kinematic body
# must remain at the top of the tree, as it will only move and rotate it's children.

export (float, 0, 10) var moveSpeed = 4 # Movement velocity.
export (float, 0, 10) var turnRate = 10 # Turning velocity.
export (float, 0, 90) var maxSlope = 45 # Max incline degrees this entity can climb.

signal play_animation

onready var aiController = get_node("AIController")
onready var navigator = get_node("Navigator")
onready var primaryAttack = get_node("PrimaryAttack")

func _physics_process(delta):
	if(primaryAttack.target != null):
		look_at_target(primaryAttack.target.global_transform.origin, delta)
	elif(global_transform.origin.distance_to(navigator.AIController.currentTarget.transform.origin) < 3):
		look_at_target(navigator.AIController.currentTarget.transform.origin, delta)
	elif(navigator.has_path()):
		look_at_target(navigator.get_current_path_point(), delta)

# Main behaviour loop.
func seek_behaviour(delta):
	var direction = navigator.get_path_direction()
	move(direction)

# Rotates towards a target Vector3.
func look_at_target(target, delta):
	if(aiController.currentState == aiController.AI_STATE.DEAD):
		return
	var direction = target - global_transform.origin
	rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * turnRate)

# Moves this object in the direction of the next path point.
func move(direction):
	move_and_slide(direction.normalized() * moveSpeed, Vector3.UP, true, 3, deg2rad(maxSlope), false)

func disable_collisions():
	get_node("ColliderMain").disabled = true
