extends KinematicBody
# This class handles the seeking behaviour for the zombie AI. The kinematic body
# must remain at the top of the tree, as it will only move and rotate it's children.

export (float, 0, 10) var moveSpeed = 4 # Movement velocity.
export (float, 0, 10) var turnRate = 10 # Turning velocity.
export (float, 0, 90) var maxSlope = 45 # Max incline degrees this entity can climb.

signal play_animation

puppet var puppetTransform = Vector3.ZERO setget puppet_transform_set
puppet var puppetRotation = 0

onready var aiController = get_node("AIController")
onready var navigator = get_node("Navigator")
onready var primaryAttack = get_node("PrimaryAttack")
onready var tween = get_node("Tween")

func _physics_process(delta):
	if(is_network_master() == false):
		rotation.y = lerp_angle(rotation.y, puppetRotation, delta * 8)
		return
	if(is_instance_valid(primaryAttack.currentTarget)):
		look_at_target(primaryAttack.currentTarget.global_transform.origin, delta)
		return
	if(navigator.has_path()):
		look_at_target(navigator.get_current_path_point(), delta)
		return

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


func puppet_transform_set(newValue):
	puppetTransform = newValue
	tween.interpolate_property(self, "global_transform:origin", global_transform.origin, puppetTransform, 0.1)
	tween.start()

func _on_NetworkTickRate_timeout():
	if(is_network_master()):
		rset_unreliable("puppetTransform", global_transform.origin)
		rset_unreliable("puppetRotation", rotation.y)
