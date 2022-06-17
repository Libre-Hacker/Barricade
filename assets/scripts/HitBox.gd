extends Area
# Area defined by the collider that can be hit by attacks.

export (float, 0, 10) var  multiplier = 1 # Multiply the damaged received by this amount.

signal hitbox_collision
signal hitbox_hit_heal
signal ragdoll_collision


# Called by the attacker to cause damage.
func damage(value = 0, entity = null, hitDirection = Vector3.ZERO):
	emit_signal("hitbox_collision", value * multiplier, entity)
	emit_signal("ragdoll_collision", hitDirection)

func heal(value = 0, entity = null):
	emit_signal("hitbox_hit_heal", value, entity)


func is_repairable():
	if(get_parent().get_node("Health").health < get_parent().get_node("Health").maxHealth and get_parent().isNailed):
		return true
	else:
		return false
