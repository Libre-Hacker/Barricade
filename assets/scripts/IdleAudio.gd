extends Node
# Plays a random sound from the idleSound array.

export (Array, Resource) var idleSounds = []
export var emitChance = 0.5

var alive = true

signal play_3dsound(stream)

# Returns a random index from the idleSounds array.
func get_random_sound(soundArray = []):
	randomize()
	return round(rand_range(0,soundArray.size()-1))

# Plays a random sound.
func playSound():
	if(alive == true):
		emit_signal("play_3dsound", idleSounds[get_random_sound()])

# Rolls to see if a sound will be emitted.
func _on_Timer_timeout():
	randomize()
	if(rand_range(0,1) >= emitChance):
		playSound()

func _on_destroyed():
	alive = false
