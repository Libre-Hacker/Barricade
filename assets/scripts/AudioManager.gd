extends Node
# Send signals to this node to spawn 3 types of audio streams that are created and destroyed by
# this node.

var currentMusic = null

# Creates a new non-positional sound.
func new_sound(stream = "", volumedb = 0.0, loop = false, bus = "Sound"):
	var newAudio = load("res://assets/scenes/AudioNode.tscn").instance()
	newAudio.set_stream(stream)
	newAudio.volume_db = volumedb
	if(loop):
		newAudio.loop = true
	newAudio.bus = bus
	add_child(newAudio)

# Creates a new 3D sound, position must be set.
func new_3d_sound(stream = "", position = Vector3.ZERO, volumedb = 0.0, unitSize = 1, loop = false, bus = "Sound"):
	var newAudio = load("res://assets/scenes/AudioNode3D.tscn").instance()
	newAudio.set_stream(stream)
	newAudio.transform.origin = position
	newAudio.unit_db = volumedb
	newAudio.unit_size = unitSize
	if(loop):
		newAudio.loop = true
	newAudio.bus = bus
	add_child(newAudio)

# Creates a new music stream, only one can exist at a time.
func new_music(stream = "", volumedb = 0.0, loop = false, bus = "Music"):
	if(currentMusic != null):
		if(currentMusic.stream ==  stream):
			return
		else:
			stop_music()
			yield(currentMusic, "tree_exited")
	var newAudio = load("res://assets/scenes/AudioNode.tscn").instance()
	newAudio.set_stream(stream)
	newAudio.volume_db = volumedb
	if(loop):
		newAudio.loop = true
	newAudio.bus = bus
	currentMusic = newAudio
	newAudio.connect("tree_exiting", self, "_on_music_finished")
	add_child(newAudio)

# Stops the current music.
func stop_music():
	if(currentMusic != null):
		currentMusic.queue_free()

func _on_music_finished():
	currentMusic = null
