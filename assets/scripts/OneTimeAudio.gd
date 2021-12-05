extends AudioStreamPlayer

func _ready():
	play()

func _on_sound_finished():
	queue_free()

