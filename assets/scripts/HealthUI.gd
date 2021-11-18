extends Panel

const health = preload("res://assets/resources/player_health.tres")
onready var healthLabel = get_node("HBoxContainer/HealthLabel")

func _process(_delta):
	healthLabel.text = str(health.Value)
