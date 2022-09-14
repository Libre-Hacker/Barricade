extends Area
class_name AreaExtended
# Improves upon the Area node by improving on tracking of bodies and adds new signals.

# Keep track of our own collisions because get_overlapping_bodies() is unreliable.
var bodyCount = [] 
var areaCount = []

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
	if(bodyCount.empty() and areaCount.empty()):
		return true
	else:
		return false

# Keeps track of collision state, signals when clear.
func _on_body_exited(body):
	bodyCount.erase(body)
	if(bodyCount.empty()):
		emit_signal("area_empty")

# Keeps track of collision state, signals the area is not clear
func _on_body_entered(body):
	bodyCount.append(body)
	emit_signal("area_occupied")

func _on_area_entered(area):
	areaCount.append(area)
	emit_signal("area_occupied")
	
func _on_area_exited(area):
	areaCount.erase(area)
	if(areaCount.empty()):
		emit_signal("area_empty")
