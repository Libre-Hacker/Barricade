extends RayCast
class_name RayCastAll

# Hits all objects along the ray, and records the collision data in an array.
func get_collision_data():
	var collisionDataArray = []
	
# RaycastAll is acheived by recording the current collision data, then adding the current object to the
# exemption list. When the ray is no longer detecting any collisions, it has hit everything along its 
# path. For now we just clear all exemptions, but to make this extendable a list of exemptions should 
# be created, # then cleared.
	while(is_colliding()):
		var collisionData = CollisionData.new()
		collisionData.collider = get_collider()
		collisionData.collisionPoint = get_collision_point()
		collisionDataArray.append(collisionData)
		add_exception(get_collider())
		force_raycast_update()

	clear_exceptions()
	return collisionDataArray
