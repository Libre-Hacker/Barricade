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
	.damage(value)
	# Play audio on global manager so sound is not deleted when zombie is destroyed.
	AudioManager.new_3d_sound(hurtSounds[round(rand_range(0,hurtSounds.size() - 1))], global_transform.origin)
	emit_signal("health_changed", entity, value)
	is_destroyed()

# Checks if the zombie has been killed.
func is_destroyed():
	if(health <= 0):
		print(get_parent().name, " is destroyed.") # For debugging
		emit_signal("change_state", 3)
		emit_signal("destroyed") # Emit signal for zombie manager to spawn another zombie.
		yield(get_tree().create_timer(despawnTime), "timeout")
		get_parent().queue_free()
