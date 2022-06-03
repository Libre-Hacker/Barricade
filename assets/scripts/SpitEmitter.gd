extends AreaExtended

export (Resource) var missSound
export (Resource) var hitSound
export (Resource) var attackSound

export var projectileDamage = 5.0
export (Vector3) var velocity
export var randomness = 1.0
export var projectileCount = 1
export var attackCooldownTime = 1

onready var projectile = preload("res://assets/scenes/SpitProjectile.tscn")

var primaryTarget = null
var target = null # Keep target variable for optimization.
var storedTarget = null
var hitPoint

signal play_animation(animationName)
signal targets_available # Emit's when viable targets are in range.
signal targets_unavailable # Emit's when no targets are within area.
signal play_3dsound(stream)

onready var lineOfSight = get_node("LineOfSight")
onready var attackCDTimer = get_node("AttackCDTimer")
onready var aiController = get_parent().get_node("AIController")

func _ready():
	attackCDTimer.start(attackCooldownTime)

# Main behaviour loop.
func attack_behaviour():
	find_target()
	if(target != null):
		storedTarget = target
		emit_signal("play_animation", "Attack", true)

# Establishes a target by checking if there is line of sight to each object
# in the area.
func find_target():
	if(target != null): # Saves execution if target still exists.
		return
	for object in areaCount:
		if(lineOfSight.has_line_of_sight(object)):
			target = object
			return
	if(target == null):
		emit_signal("targets_unavailable")

# A priority target is a player or a nailed prop.
func is_priority_target(hitbox):
	if(hitbox.is_in_group("Players") or hitbox.is_in_group("Props")):
		return true
	else:
		return false

# Keeps track of any hitboxes inside the detection area.
# Signals the AI controller if priority targets are available.
func _on_area_entered(area):
	areaCount.append(area)
	if(is_priority_target(area)):
		emit_signal("targets_available")

# Removes any hitboxes leaving the detection area.
# Signals the AI controller if no targets are available.
func _on_area_exited(area):
	areaCount.erase(area)
	if(area == target):
		target = null
	if(areaCount.empty()):
		emit_signal("targets_unavailable")

func shoot_projectiles():
	for projectiles in projectileCount:
		var newProjectile = projectile.instance()
		add_child(newProjectile)
		newProjectile.look_at(storedTarget.global_transform.origin, Vector3.UP)
	storedTarget = null
