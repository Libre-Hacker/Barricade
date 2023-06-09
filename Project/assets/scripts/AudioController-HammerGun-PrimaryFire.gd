extends Node

var _firing = false

onready var windUp = get_node("WindUp")
onready var windDown = get_node("WindDown")
onready var run = get_node("Run")

func start_firing():
	if(!_firing):
		windUp.play()
		_firing = true

func _on_WindUp_finished():
	if(_firing):
		run.play()

func stop_firing():
	if(_firing):
		_firing = false
		windUp.stop()
		run.stop()
		windDown.play()
