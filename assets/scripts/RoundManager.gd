extends Node
# Updates a timer for the length of each round and intermission. 
# Sends signals to the managers when rounds change.
# The round times are input into an array via the inspector. 
# Index 0 is the prepare round, odd indexes are attack rounds, and even indexes 
# are intermissions.

export (AudioStream) var prepareMusic
export (AudioStream) var roundStartMusic
export (AudioStream) var roundEndMusic
export (Array, float) var roundTimes = [] # A list of rounds and their time length.

var attackRound = false
var currentRound = 0 # The current round the game is on.

signal round_finished
signal round_started
signal last_round_ended

onready var roundTimer = get_node("RoundTimer")


func _ready():
	set_roundTimer(roundTimes[currentRound])
	AudioManager.new_music(prepareMusic)


# DELETE LATER FOR TESTING ONLY
func _unhandled_input(event):
	if(event.is_action_pressed("next_round")):
			roundTimer.start(0.01)


# Sets and starts the timer to the given perameter.
func set_roundTimer(time = 0):
	roundTimer.start(time)


# Checks if this round was the last, and updates the current round and timer accordingly.
func _on_RoundTimer_timeout():
	if(currentRound % 2 != 0):
		emit_signal("round_finished")
		AudioManager.new_music(roundEndMusic)
		attackRound = false
	else:
		emit_signal("round_started")
		AudioManager.new_music(roundStartMusic)
		attackRound = true
	if(currentRound < roundTimes.size()-1):
		currentRound += 1
	else:
		emit_signal("last_round_ended")
		return
	set_roundTimer(roundTimes[currentRound])
