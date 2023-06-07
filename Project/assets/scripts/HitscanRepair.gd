extends RayCast

var _repairValue: float # Set by parent
var _damageValue: float # Set by Parent
var player = null # Set by parent

onready var repairParticleEffect = preload("res://assets/scenes/RepairParticle.tscn")

func is_hitting_zombie():
	if(get_collider() != null and get_collider().is_in_group("Zombies")):
		return true
	else:
		return false

func is_hitting_prop():
	if(get_collider() != null and get_collider().is_in_group("Props")):
		return true
	else:
		return false

func hit_target():
	if(is_colliding() == false):
		return false
	var hitObject = get_collider()
	
	if(hitObject.is_in_group("Props") and hitObject.is_repairable()):
		hitObject.heal(_repairValue)
		emitImpactEffect(get_collider().get_path(), get_collision_point())

	if(is_hitting_zombie()):
		hitObject.damage(_damageValue)

func emitImpactEffect(path, position):
	var particleInstance = repairParticleEffect.instance()
	get_node(path).add_child(particleInstance)
	particleInstance.global_transform.origin = position
