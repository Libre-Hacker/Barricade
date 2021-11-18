extends Area
class_name AreaExtended

# Improves upon the Area node by improving on tracking of bodies and adds new
# signals.

# Keep track of our own collisions because 
# get_overlapping_bodies() is unreliable.
var bodyCount = [] 

signal area_empty # Signals this area is unoccupied.
signal area_occupied # Signals this area is occupied.

# Need to let listeners know if this area is empty on game start.
func _ready():
	if(is_clear()):
		emit_signal("area_empty")
	else:
		emit_signal("area_occupied")

# Checks if this object has no overlapping bodies.
func is_clear():
	if(bodyCount.empty()):
		return true
	else:
		return false

# Keeps track of collision state, signals when clear.
func _on_body_exited(body):
	print(body, " Exit")
	bodyCount.erase(body)
	if(bodyCount.empty()):
		emit_signal("area_empty")

# Keeps track of collision state, signals the area is not clear
func _on_body_entered(body):
	print(body, " Enter")
	bodyCount.append(body)
	emit_signal("area_occupied")

