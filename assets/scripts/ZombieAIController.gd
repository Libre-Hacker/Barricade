extends Node
# This class controls the AI state. Sibling nodes send signals about their state
# for this class to determine if a state change is necessary. It sends outbound
# signals every frame to the nodes executing the appropriate behaviour.

enum AI_STATE {IDLE, SEEK, ATTACK} # List of possible states.

var currentState = AI_STATE.SEEK # The current state the AI is in.
var currentTarget = null

signal seek
signal attack

onready var obstructedTimer = get_node("ObstructedTimer")

func _ready():
	GameManager.playerManager.connect("player_died", self, "find_new_target")
	find_new_target()

# Use physics process, because the behaviour nodes rely on physics.
func _physics_process(delta):
	send_current_state(delta)

# Gets a new target from the PlayerManager.
func find_new_target():
	if(GameManager.playerManager.players.size() != 0):
		currentTarget = GameManager.playerManager.players[0]
	else:
		_on_change_state(0)
		yield(GameManager.playerManager, "player_respawned")
		currentTarget = GameManager.playerManager.players[0]
		_on_change_state(1)

# Sends the signal for the current state.
func send_current_state(delta):
	match currentState:
		AI_STATE.IDLE:
			return
		AI_STATE.SEEK:
			emit_signal("seek", delta)
		AI_STATE.ATTACK:
			emit_signal("attack")

# Changes the current state.
func _on_change_state(newState : int):
	if(newState == currentState):
		print("ERROR: Current state already is: ", AI_STATE.keys()[newState])
		return
	currentState = newState
	print("Switching state to: ", AI_STATE.keys()[currentState])

func _on_KinematicBody_obstructed(value):
	obstruction_countdown(value)

# Starts / stops, the obstruction timer.
func obstruction_countdown(value):
	if(value and obstructedTimer.is_stopped()):
		obstructedTimer.start()
	elif(value == false):
		obstructedTimer.stop()

func _on_ObstructedTimer_timeout():
	_on_change_state(2)

func _on_PrimaryAttack_targets_available():
	_on_change_state(2)

func _on_PrimaryAttack_targets_unavailable():

	if(GameManager.playerManager.players.size() != 0):
		_on_change_state(1)
