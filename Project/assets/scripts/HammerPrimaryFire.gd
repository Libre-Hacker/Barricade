extends Spatial
# Repairs/damages props, and attacks enemies.

export (float,0,100) var repairValue # How much health is repaired per swing.
export (float,0,100) var damageValue # How much damage is done per swing.
export (Resource) var swingSound
export (Resource) var hitSound

signal play_animation
signal repairing
signal damaging
signal play_3d_sound

var repairParticleNode = preload("res://assets/scenes/RepairParticle.tscn")

onready var timer = get_node("AttackRate")
onready var raycast = get_node("Raycast")
onready var audioController = get_node("AudioController")

func _ready():
	raycast._repairValue = repairValue
	raycast._damageValue = damageValue

func primary_fire():
	audioController.start_firing()
	if(!raycast.is_hitting_prop()):
		emit_signal("damaging", true)
		emit_signal("repairing", false)
	else:
		emit_signal("damaging", false)
		emit_signal("repairing", true)
	if(timer.is_stopped()):
		emit_signal("play_animation", "primary_fire")
		timer.start()

func stop_primary_fire():
	emit_signal("repairing", false)
	emit_signal("damaging", false)
	emit_signal("play_animation", "RESET", true)
	audioController.stop_firing()
