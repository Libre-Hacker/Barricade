extends AudioStreamPlayer3D
# Simple audio player for 3D positional sounds.

var loop = false

func _on_sound_finished():
	if(loop):
		play()
	else:
		queue_free()
