extends Health
# Manages the zombies health, and its specific overrides.

export (Array, Resource) var hurtSounds
export (Resource) var deathSound
export var despawnTime = 3.0
signal change_state

# Damages zombie and plays audio.
func _on_hitbox_collision(value, entity):
	if(health <= 0):
		return
	var damageDone = value
	if(value > health):
		damageDone = health
	.damage(value)
	rpc("play_hit_effects")
	# Play audio on global manager so sound is not deleted when zombie is destroyed.

	get_node("Reward").add_contribution(entity, damageDone)
	if(health <= 0):
		rpc("is_destroyed")

sync func play_hit_effects():
	AudioManager.new_3d_sound(hurtSounds[round(rand_range(0,hurtSounds.size() - 1))], global_transform.origin)

# Checks if the zombie has been killed.
sync func is_destroyed():
		print(get_parent().name, " is destroyed.") # For debugging
		get_node("Reward").distribute_reward(maxHealth)
		emit_signal("change_state", 3)
		emit_signal("destroyed") # Emit signal for zombie manager to spawn another zombie.
		yield(get_tree().create_timer(despawnTime), "timeout")
		get_parent().queue_free()
