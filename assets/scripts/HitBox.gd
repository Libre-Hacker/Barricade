extends Area

export (float, 0, 10) var  multiplier = 1

signal hit(damage)

func damage(value):
	emit_signal("hit", value * multiplier)
