extends Node

func apply_status_effect(effect):
	var newEffect = effect.instance()
	for child in get_children():
		if(child == effect):
			remove_child(child)
	add_child(newEffect)
