extends Area

export (float, 0, 10) var  multiplier = 1

signal hitbox_collision(damage)

func damage(entity, value):
	emit_signal("hitbox_collision", entity , value * multiplier)
