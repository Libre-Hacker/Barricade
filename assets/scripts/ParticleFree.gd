extends Spatial

onready var despawnTimer = get_node("DespawnTimer")

func _on_DespawnTimer_timeout():
	queue_free()
