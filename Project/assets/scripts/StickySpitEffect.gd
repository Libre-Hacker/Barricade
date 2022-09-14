extends Node

export var speedModifier = 0.25

func _process(delta):
	speedModifier += 0.75*delta
	speedModifier = clamp(speedModifier,0,1)
	if(get_node("Timer").time_left <= 0.2):
		get_node("CanvasLayer/AnimationPlayer").play("Fade")

func on_expire():
	queue_free()
