extends Spatial

# Look's at the given object, and cycles through each raycast to see there is a
# collision with the given object.
func has_line_of_sight(object):
	transform.basis = Vector3.ZERO # Resets our rotation to prevent look_at error.
	look_at(object.global_transform.origin, Vector3.UP)
	for ray in get_children():
		ray.enabled = true
		ray.force_raycast_update()
		var collision = ray.get_collider()
		ray.enabled = false
		if(collision == object):
			get_parent().hitPoint = ray.get_collision_point()
			return true
