extends Spatial
# Repairs/damages props, and attacks enemies.

export (float,0,100) var repairAmount # How much health is repaired per swing.
export (float, 0,10) var repairCycleTime
export (float,0,100) var damage # How much damage is done per swing.
export (float,0,10) var attackCycleTime
export (Resource) var swingSound
export (Resource) var hitSound

signal play_animation
signal play_3d_sound

var repairParticleNode = preload("res://assets/scenes/RepairParticle.tscn")

onready var player = find_parent('FPSPlayer')
onready var cycleTimer = get_node("CycleTimer")
onready var repair = get_node("Repair")

func _ready():
	repair.player = player
	repair.repairAmount = repairAmount

# Swings the Hammer, repairing nailed props.
func primary_fire():
	emit_signal("play_animation", "repair")
	cycleTimer.start(repairCycleTime)
