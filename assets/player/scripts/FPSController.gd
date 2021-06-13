extends KinematicBody

export var speed : float = 5.0
export var jumpSpeed : float = 6.5
var velocity : Vector3 = Vector3()

func _physics_process(delta):
	move()

func move():
	calculate_movement()
	move_and_slide(velocity,Vector3.UP, true)

func calculate_movement():
	velocity.x = get_input().x * speed
	velocity.z = get_input().z * speed
	velocity.y = gravity()
	jump()
	

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
	inputDirection = inputDirection.normalized()
	return inputDirection

func gravity():
	if self.is_on_floor():
		return -0.1
	else:
		return velocity.y-0.326

func jump():
	if Input.is_action_just_pressed("jump") and self.is_on_floor():
		velocity.y = jumpSpeed
