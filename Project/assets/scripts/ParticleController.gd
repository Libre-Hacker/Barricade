extends Spatial

onready var despawnTimer = get_node("DespawnTimer")
onready var emitters = get_node("Emitters").get_children()
export var emitting = false

func set_emitting(value):
	emitting = value
	for emitter in emitters:
		emitter.emitting = value

func get_emitting():
	return emitting

func _ready():
	set_emitting(emitting)

func _on_DespawnTimer_timeout():
	queue_free()

func emit_once():
	for emitter in emitters:
		emitter.restart()
