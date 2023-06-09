extends Spatial

export (Resource) var missSound
export (Resource) var hitSound
export (Resource) var attackSound

export var attackDamage = 5.0

sync var currentTarget = null setget set_current_target
var targets = []

signal play_animation(animationName)
signal play_network_animation
signal targets_available # Emit's when viable targets are in range.
signal targets_unavailable # Emit's when no targets are within area.
signal play_3dsound(stream)

onready var lineOfSight = get_node("LineOfSight")
onready var attackCDTimer = get_node("AttackCDTimer")
onready var playerDetector = get_node("PlayerDetector")
onready var propDetector = get_node("PropDetector")
onready var navigator = get_parent().get_node("Navigator")
onready var AIController = get_parent().get_node("AIController")


func set_current_target(value):
	if(value != null):
		currentTarget = get_node(value)
	else:
		currentTarget = null

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
	availableTargets.append_array(playerDetector.areaCount)
	availableTargets.append_array(propDetector.areaCount)
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
	if(propTarget == null and playerTarget == null):
		return
	if(propTarget != null):
		currentTarget = propTarget
	else:
		currentTarget = playerTarget


# Main behaviour loop.
func attack_behaviour():
	if(attackCDTimer.is_stopped() == false):
		return
	if(is_instance_valid(currentTarget) == false):
		return
	if(navigator.has_path()):
		emit_signal("play_animation", "WalkAttack", true, true)
	else:
		emit_signal("play_animation", "Attack", true, true)
	attackCDTimer.start()

# Damages the target, called by the AnimationPlayer
func damage_target():
	if(is_network_master() == false):
		return
	if(is_instance_valid(currentTarget) == false or AIController.currentState == AIController.AI_STATE.DEAD):
		return
	if(lineOfSight.has_line_of_sight(currentTarget)):
		emit_signal("play_3dsound", hitSound)
		currentTarget.damage({value = attackDamage, entity = get_owner()})
	else:
		emit_signal("play_3dsound", missSound)
