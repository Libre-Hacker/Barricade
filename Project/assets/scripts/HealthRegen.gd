extends Node

export var healthComponent : NodePath
export (float, 0) var regenPerTick = 1
export (float, 0) var tickRateMS = 1000

func _ready():
	if(!get_node(healthComponent) is Health):
		push_error(get_node(healthComponent).to_string() + " node is not of type: Health!")
	var timer = get_node("Timer")
	timer.wait_time = tickRateMS / 1000

func _on_timeout():
	get_node(healthComponent).heal(regenPerTick)
