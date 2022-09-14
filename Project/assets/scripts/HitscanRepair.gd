extends RayCast

onready var repairParticleEffect = preload("res://assets/scenes/RepairParticle.tscn")

func repair(value = 0, player = null):
	if(is_colliding() == false):
		return false
	var hitObject = get_collider()

	if(hitObject.is_in_group("Props") and hitObject.is_repairable()):
		hitObject.heal(value, player)
		rpc("emitImpactEffect", get_collider().get_path(), get_collision_point())
		return true


remotesync func emitImpactEffect(path, position):
	var particleInstance = repairParticleEffect.instance()
	get_node(path).add_child(particleInstance)
	particleInstance.global_transform.origin = position

