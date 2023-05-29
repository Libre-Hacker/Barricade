extends Health


func _on_hitbox_collision(damageReceived = 0, entity = null):
	.damage(damageReceived)

# Applies haling.
func _on_hitbox_hit_heal(value):
	.heal(value)

func _on_death():
	GameManager._on_all_players_dead()
