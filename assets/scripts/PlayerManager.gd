extends Node

onready var players = get_children()
onready var playersAlive = players.size()-1
onready var playerSpawners = get_tree().get_root().find_node("PlayerSpawners",true,false)
signal all_players_dead

func _ready():
	yield(playerSpawners, "spawner_available")
	spawn_players()

func spawn_players():
	if(get_children().size() == 0):
		var newPlayer = load("res://assets/scenes/FPSPlayer.tscn").instance()
		var spawnPoint = playerSpawners.get_random_spawner()
		if(spawnPoint == null):
			# If no spawner is found, wait until one becomes available.
			# This saves countless computing time.
			yield(playerSpawners, "spawner_available")
			return
		newPlayer.transform.origin = spawnPoint.transform.origin
		add_child(newPlayer)
		newPlayer.connect("player_died", self, "_on_player_death")
		players.append(newPlayer)
		playersAlive += 1

func respawn_player(player):
	player.get_node("Camera").make_current()
	player.transform.origin = playerSpawners.get_random_spawner().transform.origin
	player.health = 100
	add_child(player)

func _on_player_death(player, respawn = false):
	if(respawn):
		remove_child(player)
		yield(get_tree().create_timer(5), "timeout")
		respawn_player(player)
		return
	playersAlive -= 1
	if(playersAlive <= 0):
		emit_signal("all_players_dead")
