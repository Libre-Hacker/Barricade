extends RayCastAll
# Functions for nailing props to surfaces and removing nails from props.

export(int,1,200) var ammo # Current amount of nails held.
export(int,1,200) var maxAmmo # Maximum nails the player can hold.
export (float,0,10) var cycleTime
export (float,0,2) var nailSize = 1 # How long a nail is.
export (float,0,10) var nailRange # How far the hammer can nail.
export (float,0,1) var nailMargin # How much of the nail has to be exposed.
export (Resource) var nailSound


signal play_animation(animationName)
signal nail_prop
signal play_3d_sound
signal update_ammo_display

var nailNode = preload("res://assets/scenes/Nail.tscn")

onready var cycleTimer = get_node("CycleTimer")

func _ready():
	cast_to.z = nailRange

# Checks if there are nailable objects present
func nail():
	if (ammo <= 0):
		return
	var raycastData = get_collision_data()
	var propData = get_prop(raycastData)
	var surfaceData = get_surface(raycastData)
	
	if(propData == null 
		or surfaceData == null
		or propData.collider.isNailed == true
		or propData.collisionPoint.distance_to(surfaceData.collisionPoint) > nailSize - nailMargin):
			return
	
	emit_signal("play_3d_sound", nailSound)
	emit_signal("play_animation", "alt_fire", true)
	emit_signal("nail_prop")
	cycleTimer.start()
	var midpoint = (propData.collisionPoint + surfaceData.collisionPoint) / 2
	rpc("create_nail", midpoint, surfaceData.collisionPoint, propData.collider.get_path())
	ammo -= 1
	update_ui()

# Queries the RaycastAll data for the first StaticBody. We always want the first to prevent a nail
# being created through multiple walls.
func get_surface(raycastData):
	for collisionData in raycastData:
		if(collisionData.collider is StaticBody):
			return collisionData

# Queries the RaycastAll data for the first Prop. We always want the first to prevent a nail
# being created through an unintended prop.
func get_prop(raycastData):
	for collisionData in raycastData:
		if(collisionData.collider.is_in_group("Props")):
			return collisionData

# Spawns a nail instance, setting the transforms, and parent. Only unnailed props can be nailed.
sync func create_nail(position, direction, prop):
	var nailInstance = nailNode.instance()
	get_node(prop).add_child(nailInstance)
	nailInstance.global_transform.origin = position
	nailInstance.look_at(direction, Vector3.UP)
	get_node(prop).nail() # Tell the prop it has been nailed, so it can handle it's state.

# Removes a nail from a prop. Returning the prop to its rigidbody state.
func remove_nail():
	if(is_colliding() == false or get_collider().is_in_group("Props") == false or get_collider().isNailed == false or cycleTimer.is_stopped() == false):  
		return
	emit_signal("play_animation", "nail")
	emit_signal("play_3d_sound", nailSound)
	cycleTimer.start()
	ammo += 1
	update_ui()
	rpc("remove_nail_on_all_clients", get_collider().get_path())

sync func remove_nail_on_all_clients(prop):
	get_node(prop).unnail()
	get_node(prop).get_node("Nail").queue_free()

func is_ammo_full():
	if(ammo == maxAmmo):
		return true
	else:
		return false

func add_ammo(value):
	if(ammo + value >= maxAmmo):
		ammo = maxAmmo
	else:
		ammo += value
	update_ui()

func update_ui():
	emit_signal("update_ammo_display", ammo, 0)
