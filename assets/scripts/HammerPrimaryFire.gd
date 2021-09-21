extends RayCast

export (float,0,10) var repairRange # How far the hammer can reach.
export (float,0,100) var repairAmount # How much health is repaired per swing.
export (float,0,100) var damage # How much damage is done per swing.
export (float, 0,10) var coolDown # How much time between each swing.

signal play_animation(animationName)

var repairParticleNode = preload("res://assets/scenes/RepairParticle.tscn")

onready var cooldownTimer = get_node("Cooldown")

func _ready():
	cast_to.z = repairRange

func _unhandled_input(event):
	if(event.is_action_pressed("primary_fire")):
		swing()
		get_tree().get_root().set_input_as_handled()

# Swings the Hammer, repairing nailed props, or damaging unnailed props / enemies.
func swing():
	if(is_colliding() == false or cooldownTimer.is_stopped() == false):
		return

	emit_signal("play_animation", "nail")
	cooldownTimer.start()
	var hitObject = get_collider()
	
	# Try to repair first because a repairable prop has the same properties as
	# a damagable prop.
	if(hitObject.is_in_group("Props") and hitObject.isNailed):
		# Check if object is repairable so we only spawn particles and modify
		# prop health if this is true.
		if(hitObject.is_repairable()):
			hitObject.repair(repairAmount)
			emitImpactEffect()
			print("repair")
		return
	if(hitObject.is_in_group("Destructibles")):
		print("damage")
		hitObject.damage(damage)

func emitImpactEffect():
	var particleInstance = repairParticleNode.instance()
	get_collider().add_child(particleInstance)
	particleInstance.global_transform.origin = get_collision_point()
	particleInstance.look_at(get_collision_point() + get_collision_normal(), Vector3.UP) # Causes the particle to emit perpendicular to the hit surface.
	particleInstance.emitting = true

