extends RayCast

export var equipped : bool = false
var isReloading : bool = false
export (float,0,2) var nailSize = 1
export (float,0,10) var hammerReach
export (float,0,1) var nailMargin
var nailNode = preload("res://assets/scenes/Nail.tscn")
onready var animationPlayer = get_node("AnimationPlayer")
signal ammo_changed

func _ready():
	cast_to.z = hammerReach
	connect("ammo_changed", get_node("../../../HUD/AmmoCount"), "on_ammo_changed")

func _unhandled_input(event):
	if(event.is_action_pressed("alt_fire")):
		nail()
		get_tree().get_root().set_input_as_handled()


# Hits all objects along the ray, and records the collision data in an array.
func raycast_all(distance):
	var collisionDataArray = []
	cast_to.z = distance # Custom distance can be set, but isn't necessary.
	
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
	cast_to.z = hammerReach
	return collisionDataArray

# Checks if there are nailable objects present
func nail():
	var rayDistance = nailSize + hammerReach
	var raycastData = raycast_all(rayDistance)
	
	var propData = get_prop(raycastData)
	if(propData == null):
		return
	var propCollider = propData[0]
	var propCollisionPoint = propData[1]
	var surfaceCollisionPoint = get_surface(raycastData)
	if(surfaceCollisionPoint == null):
		return
	if(propCollisionPoint.distance_to(surfaceCollisionPoint) > nailSize - 0.2):
		return
	create_nail(propCollider,propCollisionPoint,surfaceCollisionPoint)

# Queries the RaycastAll data for the first StaticBody. We always want the first to prevent a nail
# being created through multiple walls.
func get_surface(raycastData):
	for i in raycastData:
		if(i.collider is StaticBody):
			return i.collisionPoint

# Queries the RaycastAll data for the first Prop. We always want the first to prevent a nail
# being created through an unintended prop.
func get_prop(raycastData):
	for i in raycastData:
		if(i.collider.is_in_group("Props")):
			return [i.collider, i.collisionPoint]

# Spawns a nail instance, setting the transforms, and parent. Only unnailed props can be nailed.
func create_nail(propToNail, propNailPoint, surfaceNailPoint):
	if(propToNail.isNailed == true):
		print("Prop is already nailed...")
		return
	var nailInstance = nailNode.instance()
	var midpoint = (propNailPoint + surfaceNailPoint) / 2
	propToNail.add_child(nailInstance)
	nailInstance.global_transform.origin = midpoint
	nailInstance.look_at(propNailPoint, Vector3.UP)
	propToNail.nail() # Tell the prop it has been nailed, so it can handle it's state.

func updateUI():
	emit_signal("ammo_changed", 0, 0)
