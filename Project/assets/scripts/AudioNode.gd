extends AudioStreamPlayer
# Simple audio player for both non-positional sounds and music.

var loop = false

func _on_sound_finished():
	if(loop == true):
		play()
	else:
		queue_free()

