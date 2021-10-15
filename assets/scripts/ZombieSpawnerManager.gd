extends Spatial

var openSpawners = []

func _ready():
	if(get_child_count() == 0):
		print("WARNING: No spawners detected ")

func find_open_spawners():
	for i in get_children():
		if(i.is_open()):
			openSpawners.append(i)

func get_spawner():
	return find_random_spawner()
	
func find_random_spawner():
	randomize()
	var respawnPoint = get_child(round(rand_range(0, get_child_count()-1)))
	if(respawnPoint.select_spawn()):
		return respawnPoint
	else:
		return null

