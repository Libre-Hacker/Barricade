extends Panel
# Display's the players remaining respawns.

const respawns = preload("res://assets/resources/player_respawns_left.tres")
onready var respawnLabel = get_node("HBoxContainer/RespawnLabel")

func _process(_delta):
	respawnLabel.text = str(respawns.Value)

