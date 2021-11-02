extends Area

export (float, 0, 10) var  multiplier = 1

signal hitbox_collision(damage)

func damage(value):
	emit_signal("hitbox_collision", value * multiplier)
