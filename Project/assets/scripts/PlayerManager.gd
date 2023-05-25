extends Node
# Manages all players spawning, death, and respawning.

onready var playerSpawners = get_tree().get_root().find_node("PlayerSpawners",true,false)

var PLAYER = null
var _lives = 1

signal all_players_dead
signal player_died
signal player_respawned

func _ready():
	spawn_player(get_tree().get_network_unique_id())
	for peerID in get_tree().get_network_connected_peers():
		spawn_player(peerID)

func spawn_player(id):
	yield(get_tree().create_timer(2), "timeout")
	PLAYER = load("res://assets/scenes/FPSPlayer.tscn").instance()
	PLAYER.transform.origin = Vector3(0, 1, 0)
	add_child(PLAYER)
	PLAYER.get_node("Health").connect("player_died", self, "_on_player_death")


# Respawns the PLAYER.
func respawn_player(PLAYER):
	PLAYER.transform.origin = Vector3(0, 1, 0)
	PLAYER.get_node("Health").health = 100

# Checks if the PLAYER has respawns available if not removes them from the game.
func _on_player_death(PLAYER):
	if(_lives > 0):
		respawn_player(PLAYER)
		_lives -= 1
	else:
		emit_signal("all_players_dead")

func free_all_players():
	for PLAYER in get_children():
		PLAYER.queue_free()
