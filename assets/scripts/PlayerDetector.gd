extends AreaExtended

var target

func _physics_process(delta):
	look_at(target.global_transform.origin, Vector3.UP)
