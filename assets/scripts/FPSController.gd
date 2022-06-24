extends KinematicBody
# Takes input from player and converts it into movement.

export(float, 0, 25, 0.01) var moveSpeed = 7.5 # The players current move speed.
export(float) var jumpSpeed = 100 # Upward momentum applied during a jump.
export(float) var fallSpeed = -0.4
export(float, 0, 90) var maxSlopeAngle = 35 # Maximum angle in degrees the player can walk up.
export(float, 0, 200) var push = 5 # Strength of force applied to props.
export(float, 0, 25) var phaseSpeed = 1.5 # Move speed while phasing.

export (Resource) var jumpSound
export (Resource) var landSound

var falling = false
var velocity : Vector3 = Vector3() # The velocity and direction to move the player by.
var speedModifier = 1.0

onready var baseMoveSpeed = moveSpeed # Players base move speed before any modifiers.
onready var audioManager = get_node("AudioManager")
onready var footSteps = get_node("Footsteps")
onready var occupiedArea = get_node("OccupiedArea") # Area taken up by the player.

func _physics_process(_delta): # Use physics because this uses a KinematicBody.
	if(GameManager.isPaused): # Disables input when game is paused.
		return
		
	move()

	if(Input.is_action_pressed("phase")):
		start_phase()
	if(Input.is_action_just_released("phase")):
		end_phase()


# Move this object.
func move():
	calculate_movement()
	var oldPos = transform.origin # Used to track distance moved for the footstep node.
	move_and_slide(velocity, Vector3.UP, true, 6, deg2rad(maxSlopeAngle), false)
	fall()
	if(is_on_floor()):
		 # Applies distance moved to the footstep node.
		footSteps.add_travel_distance(transform.origin.distance_to(oldPos))
	push_rigid_bodies()


# Calculates this objects velocity.
func calculate_movement():
	if(get_node("StatusEffects").get_child_count() > 0):
		speedModifier = get_node("StatusEffects").get_child(0).speedModifier
	else:
		speedModifier = 1.0
	velocity.x = get_input().x * (moveSpeed * speedModifier)
	velocity.z = get_input().z * (moveSpeed * speedModifier)
	
	if(jump()):
		return
	
	if(is_on_floor()):
		velocity.y = 0
		var gravityResistance = get_floor_normal()
		velocity -= gravityResistance * 9.8
	else:
		gravity()


# Returns player input as normalized Vector3.
func get_input():
	var inputDirection = Vector3()
	if Input.is_action_pressed("move_forward"):
		inputDirection += transform.basis.z
	if Input.is_action_pressed("move_backward"):
		inputDirection -= transform.basis.z
	if Input.is_action_pressed("move_right"):
		inputDirection -= transform.basis.x
	if Input.is_action_pressed("move_left"):
		inputDirection += transform.basis.x

	inputDirection = inputDirection.normalized() # Normalize vector so speed is constant in all directions.
	return inputDirection


# Returns a negative value to simulate "gravity".
func gravity():
	if(is_on_ceiling()):
		velocity.y = -1
	else:
		velocity.y += fallSpeed


# Returns a positive value to "jump".
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		audioManager.new_3d_sound(jumpSound)
		velocity.y = jumpSpeed
		return true


# Checks if player is falling, plays audio if player lands.
func fall():
	if(is_on_floor() == false and velocity.y < 0): 
		falling = true
		return
	elif(is_on_floor() and falling == true):
		falling = false
		audioManager.new_3d_sound(landSound, global_transform.origin)


# Disables collisions with props, if the player goes inside a prop then move speed is reduced, and
# weapons are disabled.
func start_phase():
	set_collision_mask_bit(2,false)
	if(is_phasing()):
		moveSpeed = phaseSpeed
		get_node("Camera/GunBelt").disable_weapons()


# Returns true if the player is inside props, false if they are not colliding with props.
func is_phasing():
	if(occupiedArea.is_clear() == false):
		return true
	else:
		return false


# Enables prop collision, resets move speed, and enables weapons if the player isn't inside any props.
func end_phase():
	if(is_phasing()):
		yield (occupiedArea, "area_empty") # Keeps us in phase until the player is free from all props.
	moveSpeed = baseMoveSpeed
	set_collision_mask_bit(2,true)
	get_node("Camera/GunBelt").enable_weapons()
	
	
# Pushes any rigid body this object collides with in a realistic way.
func push_rigid_bodies():
	if(is_phasing()):
		return
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if(collision.collider.is_in_group("Props") and collision.get_collider().isNailed == false):
			collision.collider.apply_central_impulse(-collision.normal * push)
