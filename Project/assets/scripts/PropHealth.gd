extends Health
# Manages health for prop entities.

export (Resource) var hurtSound
export (Resource) var deathSound
export (Resource) var healSound

signal give_reward

# Applies damage.
func _on_hitbox_collision(attack):
	var damageMult = 1
	
	if(get_parent().isNailed and attack.entity == GameManager.playerManager.PLAYER):
		return
	
	if(get_parent().isNailed == false and attack.entity != GameManager.playerManager.PLAYER):
		damageMult = 5

	.damage(attack.value * damageMult)
	AudioManager.new_3d_sound(hurtSound,global_transform.origin)
	if(!is_alive()):
		destroy()

# Applies healing.
func _on_hitbox_hit_heal(value, healer):
	if(is_full_health()):
		return
	
	.heal(value)
	emit_signal("give_reward", 1 * value)

# Overrides the base function for player specific uses. Handles respawning and audio.
func destroy():
	AudioManager.new_3d_sound(deathSound, global_transform.origin) 
	get_parent().queue_free()
