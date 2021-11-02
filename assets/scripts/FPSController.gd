extends KinematicBody

export(float, 0, 25, 0.01) var moveSpeed = 7.5
export(float, 0, 25, 0.01) var jumpSpeed = 6.5
export(float, -5, -0.1, 0.001) var fallSpeed = -0.326
export(float, 0,90) var maxSlopeAngle = 35
export(float,0,1000) var health = 100
export(float,0,200) var push = 5

var velocity : Vector3 = Vector3()

func _physics_process(_delta): # Use physics because this uses a KinematicBody.
	move()

# Move this object.
func move():
	calculate_movement()
	move_and_slide(velocity, Vector3.UP, true, 4, deg2rad(maxSlopeAngle), false)

# Pushes any rigid body this object collides with in a realistic way.
func push_rigid_bodies():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if(collision.collider.is_in_group("Props")):
			collision.collider.apply_central_impulse(-collision.normal * push)

# Calculates this objects velocity.
func calculate_movement():
	velocity.x = get_input().x * moveSpeed
	velocity.z = get_input().z * moveSpeed
	velocity.y = gravity() + jump()

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
	if self.is_on_floor(): # Apply a small constant down force to keep grounded.
		return -0.1
	else:
		return velocity.y + fallSpeed

# Returns a positive value to "jump".
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		return jumpSpeed
	else:
		return 0

# Flips damage value to negative.
func damage(value : float):
	if(health - value <= 0):
		print(name, " is destroyed.")
		self.queue_free()
	else:
		health -= value
		print(name, " health = ", health)
