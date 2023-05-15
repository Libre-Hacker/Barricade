extends Node
# Manages all players spawning, death, and respawning.

onready var playersAlive = 0
onready var playerSpawners = get_tree().get_root().find_node("PlayerSpawners",true,false)
onready var connectedPlayers = 1

signal all_players_dead
signal player_died
signal player_respawned

func _ready():
	spawn_player(get_tree().get_network_unique_id())
	for peerID in get_tree().get_network_connected_peers():
		spawn_player(peerID)


func spawn_player(id):
	yield(get_tree().create_timer(2), "timeout")
	var newPlayer = load("res://assets/scenes/FPSPlayer.tscn").instance()
	newPlayer.set_network_master(id)
	newPlayer.name = str(id)
	newPlayer.transform.origin = Vector3(0, 0, 0)
	add_child(newPlayer)
	newPlayer.get_node("Health").connect("player_died", self, "_on_player_death")
	playersAlive += 1


# Respawns the player.
func respawn_player(player):
	player.get_node("Camera").make_current()
	player.transform.origin = playerSpawners.get_random_spawner().transform.origin
	player.get_node("Health").health = 100
	add_child(player)

# Checks if the player has respawns available if not removes them from the game.
func _on_player_death(player, respawn = false):
	remove_child(player)
	emit_signal("player_died")
	if(respawn):
		yield(get_tree().create_timer(5), "timeout")
		respawn_player(player)
		emit_signal("player_respawned")
		return
	playersAlive -= 1
	
	# Check if any players are left, if none are, end the game.
	if(playersAlive <= 0):
		GameManager._on_all_players_dead()
		emit_signal("all_players_dead")

func free_all_players():
	for player in get_children():
		player.queue_free()
