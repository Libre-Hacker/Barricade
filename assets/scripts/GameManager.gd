extends Node

const gameStarted = preload("res://assets/resources/game_started.tres")

var zombieManager : Node
var playerManager : Node
var roundManager : Node

var currentMusic

onready var levelSwitcher = get_node("Level/SceneSwitcher")
onready var menuSwitcher = get_node("Menus/SceneSwitcher")

func _on_all_players_dead():
	menuSwitcher._on_level_changed("DefeatMenu")
	var newSound = load("res://assets/scenes/OneTimeAudio.tscn").instance()
	newSound.bus = "Music"
	newSound.set_stream(load("res://assets/sounds/music/Suspense07.mp3"))
	add_child(newSound)
	currentMusic = newSound
	end_game()

func _on_last_round_ended():
	menuSwitcher._on_level_changed("VictoryMenu")
	var newSound = load("res://assets/scenes/OneTimeAudio.tscn").instance()
	newSound.bus = "Music"
	newSound.set_stream(load("res://assets/sounds/music/Half-Life17.mp3"))
	add_child(newSound)
	currentMusic = newSound
	end_game()

func _ready():
	return_to_main_menu()

func _on_start_game():
	get_node("AudioManager/Music").stop()
	levelSwitcher._on_level_changed("levels/DevLvlLab")
	menuSwitcher.unload_level()
	if(zombieManager == null):
		zombieManager = load("res://assets/scenes/ZombieManager.tscn").instance()
		add_child(zombieManager)
	if(playerManager == null):
		playerManager = load("res://assets/scenes/PlayerManager.tscn").instance()
		add_child(playerManager)
	if(roundManager == null):
		roundManager = load("res://assets/scenes/RoundManager.tscn").instance()
		add_child(roundManager)
# warning-ignore:return_value_discarded
	playerManager.connect("all_players_dead", self, "_on_all_players_dead")
# warning-ignore:return_value_discarded
	roundManager.connect("round_started", zombieManager, "_on_round_start")
# warning-ignore:return_value_discarded
	roundManager.connect("round_finished", zombieManager, "_on_round_finished")
# warning-ignore:return_value_discarded
	roundManager.connect("last_round_ended", self, "_on_last_round_ended")
	gameStarted.Value = true

func return_to_main_menu():
	if(currentMusic != null):
		currentMusic.queue_free()
	menuSwitcher._on_level_changed("MainMenu")
	menuSwitcher.get_child(0).connect("start_game", self, "_on_start_game")

func end_game():
	gameStarted.Value = false
	levelSwitcher.unload_level()
	zombieManager.queue_free()
	playerManager.queue_free()
	roundManager.queue_free()
	zombieManager = null
	playerManager = null
	roundManager = null
	yield(menuSwitcher.get_child(0), "return_to_MainMenu")
	print("returning")
	return_to_main_menu()
	get_node("AudioManager/Music").play()
