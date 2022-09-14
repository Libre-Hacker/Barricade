extends Node
# Manages all child spawners, keeping track of which are available to be used.
# Also contains methods for selecting spawners.

onready var spawners = get_children()
var openSpawners = [] # List of available spawners.
signal spawner_available # Signals when a spawn has become available.

func _ready():
	if(spawners.size() == 0):
		#print("WARNING: No spawners detected ")
		return
	for spawn in spawners:
		spawn.connect("open", self, "_on_spawner_opened")
		spawn.connect("closed", self, "_on_spawner_closed")

# Adds spawns to the list of available spawners.
func _on_spawner_opened(spawner):
	openSpawners.append(spawner)
	emit_signal("spawner_available")

# Removes spawns from the list of available spawners.
func _on_spawner_closed(spawner):
	openSpawners.erase(spawner)

# Returns a random spawn from the list of available spawners.
func get_random_spawner():
	if(openSpawners.empty()):
		return null
	randomize()
	var spawner = openSpawners[int(round(rand_range(0, openSpawners.size()-1)))]
	openSpawners.erase(spawner)
	return spawner

