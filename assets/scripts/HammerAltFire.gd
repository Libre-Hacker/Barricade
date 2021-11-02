## Test
## Hello
extends RayCastAll

export(int,1,200) var ammo # Current amount of nails held.
export(int,1,200) var maxAmmo # Maximum nails the player can hold.
export (float,0,2) var nailSize = 1 # How long a nail is.
export (float,0,10) var nailRange # How far the hammer can nail.
export (float,0,1) var nailMargin # How much of the nail has to be exposed.

signal play_animation(animationName)
signal nail_prop
signal ammo_changed

var nailNode = preload("res://assets/scenes/Nail.tscn")
const uiLoadedAmmo = preload("res://assets/resources/loaded_ammo.tres")
const uiReserveAmmo = preload("res://assets/resources/reserve_ammo.tres")

onready var cooldownTimer = get_node("Cooldown")

func _unhandled_input(event):
	if(event.is_action_pressed("alt_fire")):
		nail()
		get_tree().get_root().set_input_as_handled()
	
	if(event.is_action_pressed("reload")):
		remove_nail()
		get_tree().get_root().set_input_as_handled()

# Checks if there are nailable objects present
func nail():
	if (ammo <= 0 or cooldownTimer.is_stopped() == false):
		return

	var raycastData = get_collision_data()
	var propData = get_prop(raycastData)
	var surfaceData = get_surface(raycastData)
	
	if(propData == null 
		or surfaceData == null
		or propData.collider.isNailed == true
		or propData.collisionPoint.distance_to(surfaceData.collisionPoint) > nailSize - nailMargin):
			return
	
	emit_signal("play_animation", "nail")
	emit_signal("nail_prop")
	cooldownTimer.start()
	create_nail(propData,surfaceData)

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
func create_nail(propData, surfaceData):
	var nailInstance = nailNode.instance()
	var midpoint = (propData.collisionPoint + surfaceData.collisionPoint) / 2
	ammo -= 1
	update_ui()
	propData.collider.add_child(nailInstance)
	nailInstance.global_transform.origin = midpoint
	nailInstance.look_at(propData.collisionPoint, Vector3.UP)
	propData.collider.nail() # Tell the prop it has been nailed, so it can handle it's state.

# Removes a nail from a prop. Returning the prop to its rigidbody state.
func remove_nail():
	if(is_colliding() == false or get_collider().is_in_group("Props") == false or get_collider().isNailed == false):  
		return
	get_collider().unnail()
	get_collider().get_node("Nail").queue_free()
	emit_signal("play_animation", "nail")
	ammo += 1
	update_ui()

func update_ui():
	uiLoadedAmmo.Value = ammo
	uiReserveAmmo.Value = 0
