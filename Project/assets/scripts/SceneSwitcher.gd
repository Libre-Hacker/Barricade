extends Node
# Loads and unloads scenes.

var currentScene
var currentScenePath
var previousScenePath = ""

# Loads the scene at the given path.
func load_scene(scenePath: String):
	unload_scene()
	currentScenePath = scenePath
	if(ResourceLoader.exists(scenePath) == false):
		print("Failed to load scene: ", scenePath, " is not a valid path...")
		return
	var newScene = load(scenePath).instance()
	
	currentScene = newScene
	add_child(newScene)

# Loads the previously loaded scene. Useful for back buttons in menus.
func load_previous_scene():
	load_scene(previousScenePath)

# Unloads the current scene.
func unload_scene():
	if(currentScene != null):
		previousScenePath = currentScenePath
		currentScene.queue_free()
		currentScene = null
