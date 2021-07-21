extends Particles

onready var despawnTimer = get_node("DespawnTimer")

func _ready():
	despawnTimer.wait_time = lifetime
	despawnTimer.start()

func _on_DespawnTimer_timeout():
	queue_free()
