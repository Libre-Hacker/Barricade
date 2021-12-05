extends Node

# Updates a timer for the length of each round and intermission. Sends signals
# sends signals to the game manager when rounds change.
# The round times are input into an array via the inspector. 
# Index 0 is the prepare round, odd indexes are attack rounds, and even indexes 
# are intermissions.

const roundCount = preload("res://assets/resources/round_count.tres")
const roundTime = preload("res://assets/resources/round_time.tres")

export (Array, float) var roundTimes = [] # A list of rounds and their time length.

var currentRound = 0 # The current round the game is on.

signal round_finished
signal round_started
signal last_round_ended

onready var roundTimer = get_node("RoundTimer")
onready var prepareMusic = get_node("PrepareMusic")
onready var roundStartMusic = get_node("RoundStartMusic")
onready var roundEndMusic = get_node("RoundEndMusic/AnimationPlayer")
func _ready():
	set_roundTimer(roundTimes[currentRound])
	get_node("PrepareMusic").play()
	
func _process(_delta):
	updateUI()

# DELETE LATER FOR TESTING ONLY
func _unhandled_input(event):
	if(event.is_action_pressed("next_round")):
			print("stopping round timer")
			roundTimer.stop()
			_on_RoundTimer_timeout()

# Sets and starts the timer to the given perameter.
func set_roundTimer(time = 0):
	roundTimer.start(time)
	print("start round ", currentRound + 1)

# Checks if this round was the last, and updates the current round and timer accordingly.
func _on_RoundTimer_timeout():
	prepareMusic.stop()
	roundStartMusic.stop()
	roundEndMusic.stop()
	if(currentRound % 2 != 0):
		emit_signal("round_finished")
		roundEndMusic.play("Fade")
	else:
		emit_signal("round_started")
		roundStartMusic.play()
	if(currentRound < roundTimes.size()-1):
		currentRound += 1
	else:
		print("GAME END")
		emit_signal("last_round_ended")
		return
	set_roundTimer(roundTimes[currentRound])

# Updates the resource variables.
func updateUI():
	roundCount.Value = currentRound
	roundTime.Value = roundTimer.time_left
