extends RayCast

var nailNode = preload("res://assets/scenes/Nail.tscn")

func _ready():
	pass

func _input(event):
	if(Input.is_action_just_pressed("alt_fire")):
		nail_prop()

func nail_prop():
	print("Attempting to nail")
	if(is_colliding() == false):
		return
	if(get_collider().is_in_group("Props")):
		print("Prop Hit")
		var hitProp = get_collider()
		var hit = get_collision_point()
		add_exception(hitProp)
		force_raycast_update()
		cast_to.z = Vector3().distance_to(hit) + 3
		if(is_colliding()):
			var nailInstance = nailNode.instance()
			var midpoint = (hit + get_collision_point()) / 2
			hitProp.add_child(nailInstance)
			nailInstance.global_transform.origin = midpoint
			print(hit)
			print(get_collision_point())
			print(to_global(nailInstance.transform.origin))
			#nailInstance.look_at(get_collision_point(), Vector3.UP)
			print(get_collider())
			print("nail")
			clear_exceptions()
		else:
			print("No Wall found")
			clear_exceptions()
	

