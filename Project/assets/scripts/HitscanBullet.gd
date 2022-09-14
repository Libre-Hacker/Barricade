extends RayCast

enum targetType {OTHER, ZOMBIE}

var buletHitParticleNode = preload("res://assets/scenes/BulletHitParticle.tscn")
var zombieHitEffect = preload("res://assets/scenes/ZombieBloodHit.tscn")

func shoot(direction = Vector3.FORWARD, damage = 0.0, force = 0.0):
	# Changes the ray direction based on the recoil value to a random direction within the recoil limits.
	cast_to.y = direction.y
	cast_to.x = direction.x
	force_raycast_update()
	if(is_colliding()):
		var target
		if(get_collider().is_in_group("Zombies")):
			target = targetType.ZOMBIE
		else:
			target = targetType.OTHER
		rpc("emitImpactEffect", target, get_collider().get_path(), get_collision_point(), get_collision_normal())
		damageObject(damage, force)

# Emits a particle effect where the bullet impacted.
sync func emitImpactEffect(type, path, position, normal):
	var particleInstance = null
	if(type == targetType.ZOMBIE):
		particleInstance = zombieHitEffect.instance()
	else:
		particleInstance = buletHitParticleNode.instance()
	if(particleInstance == null):
		push_error("No particle effect node assigned!")
	get_node(path).add_child(particleInstance)
	particleInstance.global_transform.origin = position
	# Causes the particle to emit perpendicular to the hit surface.
	if(normal == Vector3.UP):
		particleInstance.rotation_degrees.x = -90
	else:
		particleInstance.look_at(position - normal, Vector3.UP)


# Damage the object hit.
func damageObject(damage = 0.0, force = 0.0):
	if(get_collider().is_in_group("Destructibles")):
		get_collider().damage(damage, get_parent().player, -get_collision_normal() * force)
