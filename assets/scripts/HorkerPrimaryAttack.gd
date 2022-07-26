extends Spatial

export var projectileDamage = 5.0
export var randomness = 1.0
export var projectileCount = 1
export var projectileSpread = 0.2

onready var projectile = preload("res://assets/scenes/SpitProjectile.tscn")

var currentTarget = null
var targets = []

signal play_animation(animationName)
signal targets_available # Emit's when viable targets are in range.
signal targets_unavailable # Emit's when no targets are within area.
signal play_3dsound(stream)

onready var lineOfSight = get_node("LineOfSight")
onready var attackCDTimer = get_node("AttackCDTimer")

func remove_target(object):
	if(targets.has(object)):
		targets.erase(object)
	if(currentTarget == object):
		currentTarget = null
	if(targets.empty()):
		emit_signal("targets_unavailable")

func update_targets():
	if(is_network_master() == false):
		return
	var availableTargets = []
	availableTargets.append_array(get_node("PlayerDetector").areaCount)
	availableTargets.append_array(get_node("PropDetector").areaCount)
	for object in availableTargets:
		if(lineOfSight.has_line_of_sight(object)):
			if(targets.has(object) == false):
				targets.append(object)
		else:
			remove_target(object)
	select_target()
	if(targets.empty()):
		emit_signal("targets_unavailable")
	else:
		emit_signal("targets_available")

func select_target():
	if(currentTarget != null):
		return
	var propTarget = null
	var playerTarget = null
	for object in targets:
		if(object.is_in_group("Props")):
			propTarget = object
			break
		else:
			playerTarget = object
	if(propTarget != null):
		currentTarget = propTarget
	else:
		currentTarget = playerTarget


# Main behaviour loop.
func attack_behaviour():
	if(attackCDTimer.is_stopped() == false):
		return
	if(is_instance_valid(currentTarget)):
		emit_signal("play_animation", "Attack", true)
		emit_signal("play_network_animation", "Attack", true, true)
		attackCDTimer.start()

func shoot_projectiles():
	if(is_network_master() == false):
		return
	for projectiles in projectileCount:
		var targetDirection = Vector3.FORWARD
		var randomOffset = Vector3(rand_range(-projectileSpread,projectileSpread), rand_range(0, projectileSpread), 0)
		if(is_instance_valid(currentTarget)):
			targetDirection = currentTarget.global_transform.origin
		rpc("create_projectile", targetDirection, randomOffset)

sync func create_projectile(direction = Vector3.FORWARD, offset = Vector3.ZERO):
	var newProjectile = projectile.instance()
	newProjectile.look_at(direction, Vector3.UP)
	add_child(newProjectile)
	newProjectile.shoot(offset)
	
