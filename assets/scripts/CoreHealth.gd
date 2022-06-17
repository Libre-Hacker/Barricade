extends Health


func _on_hitbox_collision(damageReceived = 0, entity = null):
	.damage(damageReceived)
	is_destroyed()


# Applies haling.
func _on_hitbox_hit_heal(value, entity):
	if(.heal(value)):
		emit_signal("health_changed", entity, value)


func is_destroyed():
	if(health <= 0):
		GameManager._on_all_players_dead()
