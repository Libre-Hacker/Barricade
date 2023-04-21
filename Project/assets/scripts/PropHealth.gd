extends Health
# Manages health for prop entities.

export (Resource) var hurtSound
export (Resource) var deathSound
export (Resource) var healSound

signal updateDamageIndicator

# Applies damage.
func _on_hitbox_collision(value, entity):
	print(entity)
	if(entity != null and entity.is_in_group("Players") and get_parent().isNailed):
		return
	.damage(value)
	emit_signal("updateDamageIndicator", health/maxHealth)
	AudioManager.new_3d_sound(hurtSound,global_transform.origin)
	if(health <= 0):
		rpc("is_destroyed")
		

# Applies haling.
func _on_hitbox_hit_heal(value, entity):
	if(.heal(value)):
		emit_signal("health_changed", entity, value)
		emit_signal("updateDamageIndicator", health/maxHealth)
	emit_signal("play_3d_sound", healSound, global_transform.origin)

# Overrides the base function for player specific uses. Handles respawning and audio.
sync func is_destroyed():
	AudioManager.new_3d_sound(deathSound, global_transform.origin) 
	get_parent().queue_free()

