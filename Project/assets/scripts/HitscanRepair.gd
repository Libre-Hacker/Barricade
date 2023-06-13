extends RayCast

var _repairValue: float # Set by parent
var _damageValue: float # Set by Parent
var player = null # Set by parent

onready var repairParticleEffect01 = preload("res://assets/scenes/RepairParticle.tscn")
onready var repairParticleEffect02 = preload("res://assets/particles/ParticlesRepairImpact.tscn")
onready var meltParticleEffect01 = preload("res://assets/particles/ParticlesMeltImpact01.tscn")
onready var meltParticleEffect02 = preload("res://assets/particles/ParticlesMeltImpact02.tscn")

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
	
	var collision = {position = get_collision_point(), normal = get_collision_normal()}
	
	if(hitObject.is_in_group("Props")):
		if(hitObject.is_repairable()):
			hitObject.heal(_repairValue)
			emitImpactEffect(repairParticleEffect01, get_collider(), {position = get_collision_point()})
		else:
			emitImpactEffect(repairParticleEffect02, get_collider(), collision)
		return
	
	if(hitObject.get_collision_layer() == 1):
		emitImpactEffect(meltParticleEffect01, get_collider(), collision)
	else:
		emitImpactEffect(meltParticleEffect02, get_collider(), collision)
	if(is_hitting_zombie()):
		hitObject.damage({value = _damageValue, entity = GameManager.playerManager.PLAYER, collision = collision})


# Emits a particle effect where the bullet impacted.
func emitImpactEffect(particle, parent, collision = {position = Vector3.ZERO, normal = Vector3.ZERO}):
	var particleInstance = particle.instance()
	if(particleInstance == null):
		push_error("No particle effect node assigned!")
	parent.add_child(particleInstance)
	particleInstance.global_transform.origin = collision.position
	
	# Causes the particle to emit perpendicular to the hit surface.
	if(!collision.has("normal")):
		return
	if(collision.normal == Vector3.UP):
		particleInstance.rotation_degrees.x = -90
	elif(collision.normal == Vector3.DOWN):
		particleInstance.rotation_degrees.x = 90
	else:
		particleInstance.look_at(collision.position - collision.normal, Vector3.UP)

