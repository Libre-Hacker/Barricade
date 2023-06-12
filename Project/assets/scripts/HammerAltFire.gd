extends RayCastAll
# Functions for nailing props to surfaces and removing nails from props.

export(int,1,200) var ammo # Current amount of nails held.
export(int,1,200) var maxAmmo # Maximum nails the player can hold.
export (float,0,10) var cycleTime
export (float,0,2) var nailSize = 1 # How long a nail is.
export (float,0,10) var nailRange # How far the hammer can nail.
export (float,0,1) var nailMargin # How much of the nail has to be exposed.
export (Resource) var nailSound
export (Resource) var errorSound
export (Resource) var dryFireSound



signal play_animation
signal play_camera_animation
signal nail_prop
signal play_sound
signal update_ammo_display
signal emit_particle

var nailNode = preload("res://assets/scenes/Nail.tscn")

onready var nailParticleEffect = preload("res://assets/particles/ParticlesNailSpark01.tscn")
onready var cycleTimer = get_node("CycleTimer")

func _ready():
	cast_to.z = nailRange
	connect("play_camera_animation", find_parent("Camera").get_node("AnimationPlayer"), "_on_change_animation")

# Checks if there are nailable objects present
func nail():
	if (ammo <= 0):
		emit_signal("play_sound", dryFireSound)
		return
	var raycastData = get_collision_data()
	var propData = get_prop(raycastData)
	var surfaceData = get_surface(raycastData)
	
	if(propData == null 
		or surfaceData == null
		or propData.collider.isNailed == true
		or propData.collisionPoint.distance_to(surfaceData.collisionPoint) > nailSize - nailMargin):
			emit_signal("play_sound", errorSound)
			return
	
	emit_signal("play_camera_animation", "recoil")
	emit_signal("play_animation", "alt_fire", true)
	emit_signal("nail_prop")
	cycleTimer.start()
	var midpoint = (propData.collisionPoint + surfaceData.collisionPoint) / 2
	create_nail(midpoint, surfaceData.collisionPoint, propData.collider.get_path())
	emitImpactEffect(propData.collider.get_path(), propData.collisionPoint)
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
func create_nail(position, direction, prop):
	var nailInstance = nailNode.instance()
	get_node(prop).add_child(nailInstance)
	nailInstance.global_transform.origin = position
	nailInstance.look_at(direction, Vector3.UP)
	get_node(prop).nail() # Tell the prop it has been nailed, so it can handle it's state.

# Removes a nail from a prop. Returning the prop to its rigidbody state.
func remove_nail():
	if(is_colliding() == false or get_collider().is_in_group("Props") == false or get_collider().isNailed == false or cycleTimer.is_stopped() == false):  
		emit_signal("play_sound", errorSound)
		return
	var prop = get_collider()
	emit_signal("play_camera_animation", "recoil")
	emit_signal("play_animation", "alt_fire_unnail")
	emit_signal("emit_particle")
	cycleTimer.start()
	ammo += 1
	update_ui()
	prop.unnail()

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


func emitImpactEffect(parent, position):
	var particleInstance = nailParticleEffect.instance()
	get_node(parent).add_child(particleInstance)
	particleInstance.global_transform.origin = position
