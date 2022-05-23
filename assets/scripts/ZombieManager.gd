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
onready var navigation = get_tree().get_root().find_node("Navigation", true, false)

func _physics_process(_delta):
	spawn_zombie()

# Spawns and initializes a new zombie.
func spawn_zombie():
	if(spawnQue > 0 and enableSpawning):
		# Find a spawner.
		var spawnPoint = spawners.get_random_spawner()
		if(spawnPoint == null):
			# If no spawner is found, wait until one becomes available.
			# This saves countless computing time.
			yield(spawners, "spawner_available")
			return
		var newZombie = zombies[round(rand_range(0, zombies.size()-1))].instance()
		newZombie.transform.origin = spawnPoint.transform.origin
		add_child(newZombie)
		newZombie.get_node("Health").connect("destroyed", self, "_on_zombie_destroyed")
		newZombie.get_node("Navigator").navigation = navigation
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
