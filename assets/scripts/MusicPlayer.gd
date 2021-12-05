extends AudioStreamPlayer

export var loop = false

func _on_Music_finished():
	if(loop):
		play()
