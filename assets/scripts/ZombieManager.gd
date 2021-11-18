extends Node

# Manages all zombies. For now just handles spawning. In future this will handle
# What kind of zombies to spawn and maybe navigation requests.

export (Array, int) var maxZombiesPerRound = [] # A list of the number of zombies to spawn per round.

var currentRound = 1
var enableSpawning = false
var spawnQue = 0 # Number of zombies wiating to be spawned.

onready var spawners = get_tree().get_root().find_node("ZombieSpawners", true, false)
onready var basicZombie = preload("res://assets/scenes/Zombie.tscn")
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
		print("Spawning Zombie at ", spawnPoint.name)
		var newZombie = basicZombie.instance()
		newZombie.transform.origin = spawnPoint.transform.origin
		add_child(newZombie)
		newZombie.get_node("Health").connect("destroyed", self, "_on_zombie_destroyed")
		newZombie.get_node("Navigator").navigation = navigation
		spawnQue -= 1 # Need to remove last.

# Adds a zombie to the spawn que.
func _on_zombie_destroyed():
	yield(get_tree().create_timer(5), "timeout")
	spawnQue += 1

func _on_round_finished():
	enableSpawning = false

func _on_round_start():
	print("spawning")
	if(currentRound < maxZombiesPerRound.size()):
		currentRound += 1
	spawnQue = maxZombiesPerRound[currentRound-1]
	enableSpawning = true
	print("Spawning: ", spawnQue, " zombies.")
