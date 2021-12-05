extends AudioStreamPlayer3D

export (Array, Resource) var sounds = []

# Plays the signaled animation
func _on_change_sound(soundName):
	set_stream(soundName)
	play()

func play_random():
	if(sounds.size() == 0):
		play()
		return
	elif(sounds.size() < 2):
		set_stream(sounds[0])
		play()
		return
	else:
		randomize()
		var index = round(rand_range(0,sounds.size() - 1))
		set_stream(sounds[index])
		print("Playing Sound: ", index)
		play()
