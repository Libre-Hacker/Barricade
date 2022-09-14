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

onready var player = find_parent(str(get_network_master()))
onready var cycleTimer = get_node("CycleTimer")
onready var repair = get_node("Repair")
onready var hurtBox = get_node("HurtBox")


# Swings the Hammer, repairing nailed props, or damaging unnailed props / enemies.
func primary_fire():
	if(repair.repair(repairAmount, player)):
		emit_signal("play_animation", "repair")
		cycleTimer.start(repairCycleTime)
	else:
		hurtBox.damage = damage
		hurtBox.player = player
		print(player)
		emit_signal("play_animation", "attack")
		cycleTimer.start(attackCycleTime)
	
