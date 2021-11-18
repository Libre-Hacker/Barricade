extends Node

func _ready():
	var res = preload("res://assets/scenes/MainMenu.tscn")
	var nextScene = res.instance()
	add_child(nextScene)

func _on_trigger(sceneToLoad):
	get_child(0).queue_free()
	var nextScene = sceneToLoad.instance()
	add_child(nextScene)
	
