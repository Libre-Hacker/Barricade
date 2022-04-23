extends Node
# Manages all players spawning, death, and respawning.

onready var players = get_children()
onready var playersAlive = 0
onready var playerSpawners = get_tree().get_root().find_node("PlayerSpawners",true,false)
onready var connectedPlayers = 1

signal all_players_dead
signal player_died
signal player_respawned

func _ready():
	yield(playerSpawners, "spawner_available")
	spawn_players()

# Initial spawning of the players.
func spawn_players():
	for player in connectedPlayers:
		var spawnPoint = playerSpawners.get_random_spawner()
		if(spawnPoint == null):
			# If no spawner is found, wait until one becomes available.
			# This saves countless computing time.
			yield(playerSpawners, "spawner_available")
		var newPlayer = load("res://assets/scenes/FPSPlayer.tscn").instance()
		newPlayer.transform.origin = spawnPoint.transform.origin
		add_child(newPlayer)
		newPlayer.get_node("Health").connect("player_died", self, "_on_player_death")
		players.append(newPlayer)
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
	players = get_children()
	emit_signal("player_died")
	if(respawn):
		yield(get_tree().create_timer(5), "timeout")
		respawn_player(player)
		players = get_children()
		emit_signal("player_respawned")
		return
	playersAlive -= 1
	
	# Check if any players are left, if none are, end the game.
	if(playersAlive <= 0):
		GameManager._on_all_players_dead()
		emit_signal("all_players_dead")
