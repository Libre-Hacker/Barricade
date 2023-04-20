extends Panel
# Displays the player's health.

onready var healthLabel = get_node("HBoxContainer/HealthLabel")

func _ready():
	if(is_network_master()):
		show()

func _process(_delta):
	if(GameManager.isPaused or is_network_master() == false):
		self.hide()
	else:
		self.show()

func update_health(value):
	healthLabel.text = str(value)
