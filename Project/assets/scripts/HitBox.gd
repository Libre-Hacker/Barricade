extends Area
# Area defined by the collider that can be hit by attacks.

export (float, 0, 10) var  multiplier = 1 # Multiply the damaged received by this amount.

signal hitbox_collision
signal hitbox_hit_heal
signal ragdoll_collision
signal apply_status_effect


# Called by the attacker to cause damage.
func damage(value = 0, entity = null, hitDirection = Vector3.ZERO, statusEffect = null):
	emit_signal("hitbox_collision", value * multiplier, entity)
	emit_signal("ragdoll_collision", hitDirection)
	if(statusEffect != null):
		emit_signal("apply_status_effect", statusEffect)

func heal(value = 0, entity = null):
	emit_signal("hitbox_hit_heal", value, entity)


func is_repairable():
	if(get_parent().get_node("Health").health < get_parent().get_node("Health").maxHealth and get_parent().isNailed):
		return true
	else:
		return false
