extends Area
# Area defined by the collider that can be hit by attacks.

export (float, 0, 10) var  multiplier = 1 # Multiply the damaged received by this amount.

signal hitbox_collision
signal hitbox_hit_heal

# Called by the attacker to cause damage.
func damage(value = 0, entity = null):
	emit_signal("hitbox_collision", value * multiplier, entity)

func heal(value = 0, entity = null):
	emit_signal("hitbox_hit_heal", value, entity)
