extends Spatial

var speed = 100

func _process(delta):
	if Input.is_key_down(KEY_W):
		print_debug("Moving")
		translation = translation + Vector3.FORWARD
	pass # Replace with function body.
