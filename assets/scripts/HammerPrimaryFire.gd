extends RayCast
# Repairs/damages props, and attacks enemies.

export (float,0,10) var repairRange # How far the hammer can reach.
export (float,0,100) var repairAmount # How much health is repaired per swing.
export (float,0,100) var damage # How much damage is done per swing.
export (Resource) var swingSound
export (Resource) var hitSound

signal play_animation(animationName)
signal play_3d_sound

var repairParticleNode = preload("res://assets/scenes/RepairParticle.tscn")

onready var player = find_parent("FPSPlayer*")
onready var cooldownTimer = get_node("Cooldown")

func _ready():
	cast_to.z = repairRange

# Swings the Hammer, repairing nailed props, or damaging unnailed props / enemies.
func swing():
	if(cooldownTimer.is_stopped() == false):
		return
	cooldownTimer.start()
	emit_signal("play_animation", "nail")
	if(is_colliding() == false):
		emit_signal("play_3d_sound", swingSound)
		return
	emit_signal("play_3d_sound", hitSound)
	var hitObject = get_collider()
	# Try to repair first because a repairable prop has the same properties as a damagable prop.
	if(hitObject.is_in_group("Props") and hitObject.get_parent().is_repairable()):
		repair(hitObject)
		return # Stop exectuion so we only repair.
	if(hitObject.is_in_group("Destructibles")):
		attack(hitObject)

func repair(hitObject):
	var hitObjectHealthValues = hitObject.get_health()
	if(hitObjectHealthValues[0] < hitObjectHealthValues[1]):
		hitObject.heal(repairAmount, player)
		emitImpactEffect()

func attack(hitObject):
	hitObject.damage(damage, player)

func emitImpactEffect():
	var particleInstance = repairParticleNode.instance()
	get_collider().add_child(particleInstance)
	particleInstance.global_transform.origin = get_collision_point()

