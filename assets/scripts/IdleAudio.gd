extends AudioStreamPlayer3D

export (Array, Resource) var idleSounds = []

func _ready():
	playSound()

func get_random_sound(soundArray = []):
	randomize()
	return round(rand_range(0,soundArray.size()-1))

func playSound():
	if(!is_playing()):
		set_stream(idleSounds[get_random_sound(idleSounds)])
		play()

func _on_sound_finished() -> void:
	randomize()
	if(round(rand_range(0,1)) == 0):
		playSound()
	else:
		get_node("Timer").start()


func _on_Timer_timeout() -> void:
	playSound()
