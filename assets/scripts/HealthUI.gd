extends Panel
# Displays the player's health.

onready var healthLabel = get_node("HBoxContainer/HealthLabel")

func _ready():
	if(is_network_master()):
		show()

func update_health(value):
	healthLabel.text = str(value)
