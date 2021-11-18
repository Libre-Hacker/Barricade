extends Spatial

var targetPosition = Vector3.ZERO # The target destination to navigate to.
var pathPoints = [] # An array of points that lead to the target.
var pathIndex = 0 # The current index of the path array.
var navigation = null

onready var player = get_tree().get_root().find_node("FPSPlayer", true, false)

func _on_NavigationTimer_timeout():
	calculate_path(player.transform.origin)

# Updates the pathPoints to the current target.
func calculate_path(destination):
	pathPoints = navigation.get_simple_path(global_transform.origin, destination)
	pathIndex = 0

# Gets the direction to the current path index, and updates the path index.
func get_path_direction():
	# If true, we have reached our destination, and can return a zero vector.
	if(pathIndex >= pathPoints.size()): 
		return Vector3.ZERO
	
	if(calculate_direction().length() < 0.3 and pathIndex < pathPoints.size()-1):
		pathIndex += 1

	return calculate_direction()

# Calculates the direction to the next path point.
func calculate_direction():
	return pathPoints[pathIndex] - global_transform.origin
