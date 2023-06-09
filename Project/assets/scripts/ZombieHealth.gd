extends Health
# Manages the zombies health, and its specific overrides.

export (Array, Resource) var hurtSounds
export (Resource) var hurtParticle
export (Resource) var deathSound
export var despawnTime = 3.0
signal change_state
signal give_reward
signal destroyed

# Damages zombie and plays audio.
func _on_hitbox_collision(attack):
	.damage(attack.value)
	
	if(is_alive()):
		# Play audio on global manager so sound is not deleted when zombie is destroyed.
		AudioManager.new_3d_sound(hurtSounds[round(rand_range(0,hurtSounds.size() - 1))], global_transform.origin)

	if(!attack.has("collision")):
		return
		
	var collision = attack.collision
	var particle = hurtParticle.instance()
	self.add_child(particle)
	particle.global_transform.origin = collision.position
	
	# Causes the particle to emit perpendicular to the hit surface.
	if(collision.normal == Vector3.UP):
		particle.rotation_degrees.x = -90
	else:
		particle.look_at(collision.position - collision.normal, Vector3.UP)

func _on_death():
		emit_signal("give_reward")
		emit_signal("change_state", 3)
		emit_signal("destroyed") # Emit signal for zombie manager to spawn another zombie.
		yield(get_tree().create_timer(despawnTime), "timeout")
		get_parent().queue_free()
