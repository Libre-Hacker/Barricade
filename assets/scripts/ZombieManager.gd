extends Spatial

export(float,0,60,0.5) var respawnTime
export(int,0,100) var zombieCount

var spawnQue = 0

onready var spawners = get_node("Spawners")
onready var zombies = get_node("Zombies")
onready var basicZombie = preload("res://assets/scenes/Zombie.tscn")

func _ready():
	for i in zombieCount:
		spawnQue += 1

func _process(delta):
	spawn_zombie()

func spawn_zombie():
	if(spawnQue > 0):
		var spawnPoint = spawners.get_spawner()
		if(spawnPoint == null):
			return
		print("Spawning Zombie at ", spawnPoint.name)
		var newZombie = basicZombie.instance()
		newZombie.transform.origin = spawnPoint.transform.origin
		zombies.add_child(newZombie)
		newZombie.connect("destroyed", self, "_on_destroyed")
		spawnQue -= 1

func _on_destroyed():
	spawnQue += 1
