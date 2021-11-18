extends Node

var currentLevel
var previousLevelName

func _ready():
	if(get_child_count() == 0):
		return
	currentLevel = get_child(0)
	currentLevel.connect("level_changed", self, "_on_level_changed")

func _on_level_changed(nextLevelName: String):
	if(nextLevelName == ""):
		unload_level()
		return
	if(nextLevelName == "PreviousLevel"):
		nextLevelName = previousLevelName
	var nextLevel = load("res://assets/scenes/" + nextLevelName + ".tscn").instance()
	if(currentLevel != null):
		previousLevelName = currentLevel.name
		currentLevel.queue_free()
	currentLevel = nextLevel
	add_child(nextLevel)
	if("levels/" in nextLevelName):
		return
	nextLevel.connect("level_changed", self, "_on_level_changed")

func unload_level():
	get_child(0).queue_free()
	currentLevel = null
