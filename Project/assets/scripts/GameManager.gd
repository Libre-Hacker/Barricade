extends Node
# Global script. Managers the 3 game managers, and game state.

var zombieManager : Node
var playerManager : Node
var roundManager : Node

var isPaused = false

var core = null

func _ready():
	MenuSwitcher.load_scene("res://assets/scenes/MainMenu.tscn")
	set_process_unhandled_input(false)

func _unhandled_input(event):
	if(event.is_action_pressed("pause")):
		if(isPaused == false):
			pause_game()
			get_tree().set_input_as_handled()

# Resumes the game, hides the menu.
func resume_game():
	MenuSwitcher.unload_scene()
	isPaused = false

# Pauses the game, and displays the pause menu.
func pause_game():
	isPaused = true
	MenuSwitcher.load_scene("res://assets/scenes/PauseMenu.tscn")

# Called when start game button is pressed. Requests level changes and initializes
# the player, zombie, and round managers.
remotesync func start_game():
	AudioManager.stop_music()
	LevelSwitcher.load_scene("res://assets/scenes/levels/DevLvlWarehouse.tscn")
	MenuSwitcher.unload_scene()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Hides cursor.
	set_process_unhandled_input(true)
	instance_managers()
	core = get_tree().get_root().find_node("Core",true,false)
	if(core == null):
		push_error("Core not found!!")

# Instances and connects the player, zombie, and round managers.
func instance_managers():
	if(zombieManager == null):
		zombieManager = load("res://assets/scenes/ZombieManager.tscn").instance()
		add_child(zombieManager)

	if(playerManager == null):
		playerManager = load("res://assets/scenes/PlayerManager.tscn").instance()
		add_child(playerManager)
		# warning-ignore:return_value_discarded
		playerManager.connect("all_players_dead", self, "_on_all_players_dead")

	if(roundManager == null):
		roundManager = load("res://assets/scenes/RoundManager.tscn").instance()
		add_child(roundManager)
		# warning-ignore:return_value_discarded
		roundManager.connect("round_started", zombieManager, "_on_round_start")
		# warning-ignore:return_value_discarded
		roundManager.connect("round_finished", zombieManager, "_on_round_finished")
		# warning-ignore:return_value_discarded
		roundManager.connect("last_round_ended", self, "_on_last_round_ended")

# Ends the game with a defeat.
func _on_all_players_dead():
	MenuSwitcher.load_scene("res://assets/scenes/DefeatMenu.tscn")
	end_game()

# Ends the game with a victory.
func _on_last_round_ended():
	MenuSwitcher.load_scene("res://assets/scenes/VictoryMenu.tscn")
	end_game()

# Unloads the managers and level, and prepares the main menu scene.
func end_game():
	LevelSwitcher.unload_scene()
	set_process_unhandled_input(false)
	
	zombieManager.queue_free()
	playerManager.free_all_players()
	playerManager.queue_free()
	roundManager.queue_free()
	
	# Need to wait for next frame so managers can be freed
	yield(get_tree(), "idle_frame") 
	
	zombieManager = null
	playerManager = null
	roundManager = null

