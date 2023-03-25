extends Area

# This simply sends signals to notify the spawn manager if this spawn point can
# be used.

export (bool) var enabled = true

# Keep track of our own collisions because 
# get_overlapping_bodies() is unreliable.
var bodyCount = [] 

signal open # Signals this spawn is unoccupied and can be used.
signal closed # Signals this spawn is occupied and can't be used.

# Need to let spawn manager know if this spawn can be used at game start.
func _ready():
	# This object will be created before the spawn manager, so we need to wait
	# a small amount of time so spawn manager can initialize.
	yield(get_tree().create_timer(0.5), "timeout")
	
	if(is_open() and enabled):
		emit_signal("open", self)
	else:
		emit_signal("closed", self)

# Checks if this object has no overlapping bodies.
func is_open():
	if(bodyCount.empty()):
		return true
	else:
		return false

# Keeps track of collision state, signals when clear.
func _on_body_exited(body):
	bodyCount.erase(body)
	if(bodyCount.empty()):
		emit_signal("open", self)

# Keeps track of collision state, signals the area is not clear
func _on_body_entered(body):
	bodyCount.append(body)
	emit_signal("closed", self)


func _on_PayWall_on_purchase():
	emit_signal("open", self)
