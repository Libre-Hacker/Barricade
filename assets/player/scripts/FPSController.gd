extends KinematicBody

export(float, 0, 25, 0.01) var moveSpeed = 7.5
export(float, 0, 25, 0.01) var jumpSpeed = 6.5
export(float, -5, -0.1, 0.001) var fallSpeed = -0.326

var velocity : Vector3 = Vector3()

func _physics_process(_delta): # Use physics because this uses a KinematicBody.
	move()

# Move this object.
func move():
	calculate_movement()
	move_and_slide(velocity, Vector3.UP, true)

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
	if Input.is_action_just_pressed("jump") and self.is_on_floor():
		return jumpSpeed
	else:
		return 0
