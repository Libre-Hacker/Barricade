extends RayCast

onready var repairParticleEffect = preload("res://assets/scenes/RepairParticle.tscn")

func repair(value = 0, player = null):
	if(is_colliding() == false):
		return false
	var hitObject = get_collider()

	if(hitObject.is_in_group("Props") and hitObject.is_repairable()):
		hitObject.heal(value, player)
		emitImpactEffect()
		return true


func emitImpactEffect():
	var particleInstance = repairParticleEffect.instance()
	get_collider().add_child(particleInstance)
	particleInstance.global_transform.origin = get_collision_point()
	print(get_collision_point())

