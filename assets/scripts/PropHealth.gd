extends Health
# Manages health for prop entities.

export (Resource) var hurtSound
export (Resource) var deathSound
export (Resource) var healSound

# Applies damage.
func _on_hitbox_collision(value, entity):
	.damage(value)
	is_destroyed()

# Applies haling.
func _on_hitbox_hit_heal(value, entity):
	if(.heal(value)):
		emit_signal("health_changed", entity, value)
	emit_signal("play_3d_sound", healSound, global_transform.origin)

# Overrides the base function for player specific uses. Handles respawning and audio.
func is_destroyed():
	if(health <= 0):
		print(get_parent().name, " is destroyed.") # For debugging
		
		# Play this on the global AudioManager so sound continues after player object has been freed.
		# Might be able to change this once corpse stays in world.
		AudioManager.new_3d_sound(deathSound, global_transform.origin) 
		get_parent().queue_free()
	else:
		emit_signal("play_3d_sound", hurtSound, global_transform.origin)

