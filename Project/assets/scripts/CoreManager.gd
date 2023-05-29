extends Node

var cores = []
var CORE = null

func _ready():
	cores = get_tree().get_root().find_node("Cores", true, false).get_children()

func set_core(selectedCore):
	if(selectedCore.is_in_group("Core")):
		CORE = selectedCore
		for core in cores:
			if(core != selectedCore):
				core.queue_free()

func select_rand_core():
	var randIndex = floor(rand_range(0, cores.size()))
	set_core(cores[randIndex])

