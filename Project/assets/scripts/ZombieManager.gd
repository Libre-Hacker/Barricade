extends Node
# Manages all zombies. For now just handles spawning. In future this will handle
# What kind of zombies to spawn and maybe navigation requests.

# A list of the number of zombies to spawn per round. Index 0 is ignored, on the first round we set the index to 1.
export (Array, int) var maxZombiesPerRound = []
export (float) var respawnTime = 5 # The time it takes for a zombie to respawn.
export (Array, Resource) var zombies

var maxZombieIndex = 0
var enableSpawning = false
var spawnQue = 0 # Number of zombies wiating to be spawned.
var zombiesAlive = 0

onready var spawners = get_tree().get_root().find_node("ZombieSpawners", true, false)

func _physics_process(_delta):
	if(spawnQue <= 0 or enableSpawning == false):
		return
	var spawnPosition = get_spawn_point()
	if(spawnPosition == null):
		return
	spawnPosition = spawnPosition.global_transform.origin
	var zombieTypeIdx = get_random_zombie_to_spawn()
	spawn_zombie(spawnPosition, zombieTypeIdx)


func get_spawn_point():
	return spawners.get_random_spawner()

func get_random_zombie_to_spawn():
	return round(rand_range(0, zombies.size()-1))


# Spawns and initializes a new zombie.
func spawn_zombie(position, index):
	var newZombie = zombies[index].instance()
	newZombie.transform.origin = position
	add_child(newZombie)
	if(is_network_master()):
		newZombie.get_node("Health").connect("destroyed", self, "_on_zombie_destroyed")
		spawnQue -= 1 # Need to remove last.
		zombiesAlive += 1

# Adds a zombie to the spawn que.
func _on_zombie_destroyed():
	if(zombiesAlive > maxZombiesPerRound[maxZombieIndex]):
		zombiesAlive -= 1
		return
	zombiesAlive -= 1
	yield(get_tree().create_timer(respawnTime), "timeout")
	spawnQue += 1

# Turns spawning off.
func _on_round_finished():
	enableSpawning = false

# Enables spawning, tells the spawner how many zombies this round has.
func _on_round_start():
	maxZombieIndex += 1
	spawnQue = maxZombiesPerRound[maxZombieIndex]
	enableSpawning = true
