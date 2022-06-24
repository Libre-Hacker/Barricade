extends Spatial

export var projectileDamage = 5.0
export var randomness = 1.0
export var projectileCount = 1

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
		attackCDTimer.start()

func shoot_projectiles():
	for projectiles in projectileCount:
		var newProjectile = projectile.instance()
		add_child(newProjectile)
		if(is_instance_valid(currentTarget)):
			newProjectile.look_at(currentTarget.global_transform.origin,Vector3.UP)
		newProjectile.shoot()
