extends Health
# Manages health for prop entities.

export (Resource) var hurtSound
export (Resource) var deathSound
export (Resource) var healSound

signal updateDamageIndicator
signal give_reward

# Applies damage.
func _on_hitbox_collision(value, attacker):
	if(attacker != null and attacker.is_in_group("Players") and get_parent().isNailed):
		return
	.damage(value)
	emit_signal("updateDamageIndicator", health/maxHealth)
	AudioManager.new_3d_sound(hurtSound,global_transform.origin)
	if(is_dead()):
		destroy()

# Applies healing.
func _on_hitbox_hit_heal(value, healer):
	if(is_full_health()):
		return
	
	.heal(value)
	emit_signal("give_reward")
	emit_signal("updateDamageIndicator", health/maxHealth)
	emit_signal("play_3d_sound", healSound, global_transform.origin)

# Overrides the base function for player specific uses. Handles respawning and audio.
func destroy():
	AudioManager.new_3d_sound(deathSound, global_transform.origin) 
	get_parent().queue_free()

