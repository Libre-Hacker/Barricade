extends Spatial
# Responsible for calculating and updating the pathfinding.

export (float) var pathMargin = 0.3 # The distance margin to the next path point.
export (float) var targetMargin = 1 # The distance margin to the target.

var pathPoints = [] # An array of points that lead to the target.
var pathIndex = 0 # The current index of the path array.

onready var randomPoint = round(rand_range(-2,2))
onready var navigation = get_tree().get_root().find_node("Navigation", true, false)

# Need to replace this with an aggro system for multiplayer.
onready var AIController = get_parent().get_node("AIController")

func _on_NavigationTimer_timeout():
	if(AIController.currentState != get_parent().get_node("AIController").AI_STATE.SEEK):
		pathPoints = []
		return
	if(get_parent().transform.origin.distance_to(AIController.primaryTarget.transform.origin) > 4):
		calculate_path(AIController.primaryTarget.transform.origin + Vector3(randomPoint,0,0))
		return
	elif(get_parent().transform.origin.distance_to(AIController.primaryTarget.transform.origin) > 1):
		calculate_path(AIController.primaryTarget.transform.origin)
	else:
		pathPoints = []

# Updates the pathPoints to the current target.
func calculate_path(destination):
	# Doesn't calculate a path if the target is within the targetMargin.
	if(global_transform.origin.distance_to(AIController.primaryTarget.transform.origin) < targetMargin):
		return
	pathPoints = navigation.get_simple_path(global_transform.origin, destination)
	pathIndex = 0
	update_path_index()

# Returns true if there is a valid path.
func has_path():
	if(pathPoints.size() < 1 or pathIndex >= pathPoints.size()):
		return false
	else:
		return true

# Returns the current path point vector.
func get_current_path_point():
	return pathPoints[pathIndex]

# Gets the direction to the current path index, and updates the path index.
func get_path_direction():
	return calculate_direction()

# Updates the path array to the next point if within the margin to the current point.
func update_path_index():
	if(has_path() == false):
		return
	if(pathPoints.size() - pathIndex > 5):
		get_node("NavigationTimerShort").stop()
		if(get_node("NavigationTimerLong").is_stopped()):
			get_node("NavigationTimerLong").start()
	else:
		get_node("NavigationTimerLong").stop()
		if(get_node("NavigationTimerShort").is_stopped()):
			get_node("NavigationTimerShort").start()
	if(global_transform.origin.distance_to(pathPoints[pathIndex]) < pathMargin):
		pathIndex += 1

# Calculates the direction to the next path point.
func calculate_direction():
	update_path_index()
	if(pathIndex >= pathPoints.size()):
		return Vector3.ZERO
	return pathPoints[pathIndex] - global_transform.origin
