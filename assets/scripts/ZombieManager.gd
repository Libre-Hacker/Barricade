extends Spatial

# Manages all zombies. For now just handles spawning. In future this will handle
# What kind of zombies to spawn and maybe navigation requests.

export(int,0,100) var zombieCount = 1 # Maximum number of zombies to spawn.

onready var spawnQue = zombieCount # Number of zombies wiating to be spawned.
onready var spawners = get_node("Spawners") # Container for spawns, and their manager.
onready var zombies = get_node("Zombies") # Container for zombies. Might be needed later for loops.
onready var basicZombie = preload("res://assets/scenes/Zombie.tscn")

func _physics_process(_delta):
	spawn_zombie()

# Spawns and initializes a new zombie.
func spawn_zombie():
	if(spawnQue > 0):
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
		zombies.add_child(newZombie)
		newZombie.get_node("Health").connect("destroyed", self, "_on_zombie_destroyed")
		spawnQue -= 1 # Need to remove last.

# Adds a zombie to the spawn que.
func _on_zombie_destroyed():
	yield(get_tree().create_timer(5), "timeout")
	spawnQue += 1
