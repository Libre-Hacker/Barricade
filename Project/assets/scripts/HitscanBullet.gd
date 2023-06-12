extends RayCast

enum targetType {OTHER, ZOMBIE}

var buletHitParticleNode = preload("res://assets/particles/ParticlesBulletImpact.tscn")
var zombieHitEffect = preload("res://assets/scenes/ZombieBloodHit.tscn")

func shoot(direction = Vector3.FORWARD, damage = 0.0, force = 0.0):
	# Changes the ray direction based on the recoil value to a random direction within the recoil limits.
	cast_to.y = direction.y
	cast_to.x = direction.x
	force_raycast_update()
	if(!is_colliding()):
		return
	
	var hitbox = get_collider()
	var attack = {
		value = damage,
		entity = GameManager.playerManager.PLAYER,
		collision = {position = get_collision_point(), normal = get_collision_normal()},
		force = -get_collision_normal() * force
		}
	
	if(hitbox.get_collision_layer() != 128):
		emitImpactEffect(hitbox, attack.collision)
		
	if(hitbox.has_method("damage")):
		hitbox.damage(attack)

# Emits a particle effect where the bullet impacted.
func emitImpactEffect(parent, collision = {position = Vector3.ZERO, normal = Vector3.ZERO}):
	var particleInstance = buletHitParticleNode.instance()
	if(particleInstance == null):
		push_error("No particle effect node assigned!")
	parent.add_child(particleInstance)
	particleInstance.global_transform.origin = collision.position
	# Causes the particle to emit perpendicular to the hit surface.
	if(collision.normal == Vector3.UP):
		particleInstance.rotation_degrees.x = -90
	elif(collision.normal == Vector3.DOWN):
		particleInstance.rotation_degrees.x = 90
	else:
		particleInstance.look_at(collision.position - collision.normal, Vector3.UP)
