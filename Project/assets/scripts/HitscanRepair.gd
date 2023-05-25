extends RayCast

var repairAmount = 0 # Set by parent
var player = null # Set by parent

onready var repairParticleEffect = preload("res://assets/scenes/RepairParticle.tscn")

func repair():
	if(is_colliding() == false):
		return false
	var hitObject = get_collider()

	if(hitObject.is_in_group("Props") and hitObject.is_repairable()):
		hitObject.heal(repairAmount, player)
		emitImpactEffect(get_collider().get_path(), get_collision_point())

func emitImpactEffect(path, position):
	var particleInstance = repairParticleEffect.instance()
	get_node(path).add_child(particleInstance)
	particleInstance.global_transform.origin = position
