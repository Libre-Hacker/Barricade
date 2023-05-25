extends RigidBody
# Handles state of prop, we do not use a hit box to detect attacks because most
# props will have unique collision boxes, so the rigid body captures the attacks
# and forwards them to the health node.

export (String) var realName = "Core" # The name of the prop, for UI use.
export (float) var followSpeed : float = 7.5 # The speed the prop moves while held.

var nodeToFollow : Node # Node the prop follows while picked up.
var holdInPlace = false

signal damage_taken
signal repair_received
signal dropped

func _physics_process(_delta):
	followPoint()

# Sets class variables to enable pickup. 
# Called from outside class.
func pickup(assignedNode, player):
	if(is_picked_up() == false):
		gravity_scale = 0
		for materials in get_node("MeshInstance").get_surface_material_count():
			get_node("MeshInstance").get_surface_material(materials).flags_transparent = true
		set_collision_mask_bit(3, false) # Change collision mask so this won't collide while held.
		nodeToFollow = assignedNode
		for players in GameManager.get_node("PlayerManager").players:
			add_collision_exception_with(players)

# Resets class variables to defaults.
# Called from outside class.
func drop():
	nodeToFollow = null
	gravity_scale = 1
	if(get_node("OccupiedArea").bodyCount.size() > 0):
		yield(get_node("OccupiedArea"), "area_empty")
	for exception in get_collision_exceptions():
		remove_collision_exception_with(exception)
	set_collision_mask_bit(3, true) # Change collision mask so this won't collide while held.
	for materials in get_node("MeshInstance").get_surface_material_count():
		get_node("MeshInstance").get_surface_material(materials).flags_transparent = false

# Moves this object to the nodeToFollow variable.
func followPoint():
	if(is_picked_up()):
		var moveDistance = (nodeToFollow.global_transform.origin - transform.origin) * followSpeed
		linear_velocity = moveDistance # Use physics to detect collisions.

# Returns true if nodeToFollow is not null.
func is_picked_up():
	if(nodeToFollow == null):
		return false
	else:
		return true
