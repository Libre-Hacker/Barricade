extends Health

func _on_hitbox_collision(damageReceived = 0, entity = null):
	print("hit")
	.damage(damageReceived)
	is_destroyed()

func is_destroyed():
	if(health <= 0):
		print("GAME OVER")
		GameManager._on_all_players_dead()
