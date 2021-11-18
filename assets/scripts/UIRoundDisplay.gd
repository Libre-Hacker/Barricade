extends Panel

# Updates the UI with the values from the resources.

const roundCount = preload("res://assets/resources/round_count.tres")
const roundTime = preload("res://assets/resources/round_time.tres")
onready var roundLabel = get_node("VBoxContainer/HBoxContainer/RoundNumber")
onready var timeLeftLabel = get_node("VBoxContainer/TimeLeft")
onready var textLabel = get_node("VBoxContainer/HBoxContainer/RoundText")

func _process(_delta):
	# Shown at the start of the game.
	if(roundCount.Value == 0):
		textLabel.text = "Prepare"
		roundLabel.text = str(roundCount.Value + 1)
		format_time()
	# Updates the UI to an intermission, 
	elif(roundCount.Value % 2 == 0):
		textLabel.text = "Next Wave"
		# Need to convert the round count to the actual round number by adding 1 and
		# dividing by 2 then rounding up. NOTE: we must multiply by 0.5 instead 
		# of dividing because 1 / 2 = 0?
		roundLabel.text = str(ceil((roundCount.Value + 1) * 0.5))
		format_time()
	else:
		textLabel.text = "Round"
		# Need to convert the round count to the actual round number by
		# dividing by 2 then rounding up. NOTE: we must multiply by 0.5 instead 
		# of dividing because 1 / 2 = 0?
		roundLabel.text = str(ceil(roundCount.Value * 0.5))
		format_time()

# Formats and updates the timeLeftLabel into MM:SS
func format_time():
	var minutes = roundTime.Value / 60
	var seconds = fmod(roundTime.Value, 60)
	var timeString = "%02d:%02d" % [minutes, seconds]
	timeLeftLabel.text = timeString
