extends Area
# Area defined by the collider that can be hit by attacks.

export (float, 0, 10) var  multiplier = 1 # Multiply the damaged received by this amount.

signal hitbox_collision
signal hitbox_hit_heal
signal ragdoll_collision
signal apply_status_effect


# Called by the attacker to cause damage.
func damage(attack = {value = 0, entity = null, collision = {position = Vector3.ZERO, normal = Vector3.ZERO}, force = Vector3.ZERO, statusEffect = null}):
	emit_signal("hitbox_collision", {
		value = attack.value * multiplier,
		entity = attack.entity,
		collision = attack.collision if attack.has("collision") else null
		})
	if(attack.has("force")):
		emit_signal("ragdoll_collision", attack.force)
	if(attack.has("statusEffect")):
		emit_signal("apply_status_effect", attack.statusEffect)

func heal(value = 0, entity = null):
	emit_signal("hitbox_hit_heal", value, entity)


func is_repairable():
	if(get_parent().get_node("Health").health < get_parent().get_node("Health").maxHealth and get_parent().isNailed):
		return true
	else:
		return false
