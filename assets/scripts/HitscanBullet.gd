extends RayCast

var buletHitParticleNode = preload("res://assets/scenes/BulletHitParticle.tscn")
var zombieHitEffect = preload("res://assets/scenes/ZombieBloodHit.tscn")

func shoot(direction = Vector3.FORWARD, damage = 0.0, force = 0.0):
	# Changes the ray direction based on the recoil value to a random direction within the recoil limits.
	cast_to.y = direction.y
	cast_to.x = direction.x
	force_raycast_update()
	if(is_colliding()):
		emitImpactEffect()
		damageObject(damage, force)

# Emits a particle effect where the bullet impacted.
func emitImpactEffect():
	var particleInstance = null
	if(get_collider().is_in_group("Zombies")):
		particleInstance = zombieHitEffect.instance()
	else:
		particleInstance = buletHitParticleNode.instance()
	if(particleInstance == null):
		push_error("No particle effect node assigned!")
	get_collider().add_child(particleInstance)
	particleInstance.global_transform.origin = get_collision_point()
	# Causes the particle to emit perpendicular to the hit surface.
	if(get_collision_normal() == Vector3.UP):
		particleInstance.rotation_degrees.x = -90
	else:
		particleInstance.look_at(get_collision_point() - get_collision_normal(), Vector3.UP)


# Damage the object hit.
func damageObject(damage = 0.0, force = 0.0):
	if(get_collider().is_in_group("Destructibles")):
		get_collider().damage(damage, get_parent().player, -get_collision_normal() * force)
