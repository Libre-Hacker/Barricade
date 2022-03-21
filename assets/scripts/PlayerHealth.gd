extends Health
# Inherits the health class and extends it for use with players.

# The health UI variable.
const healthUI = preload("res://assets/resources/player_health.tres")
# The respawn UI counter variable.
const respawnCountUI = preload("res://assets/resources/player_respawns_left.tres")

export (int, 0, 3) var respawns = 0 # Number of respawns remaining.
export (Resource) var hurtSound
export (Resource) var deathSound

signal play_3d_sound
signal player_died

onready var player = get_parent()

# Set health to max health, and update the players UI.
func _ready():
	health = maxHealth
	updateUI()

# Recevied from the hitbox that was hit. Removes health from the base class.
func _on_hitbox_collision(damageReceived, attacker):
	.damage(damageReceived)
	is_destroyed()

# Overrides the base function for player specific uses. Handles respawning and audio.
func is_destroyed():
	if(health <= 0):
		print(player.name, " is destroyed.") # For debugging
		
		# Play this on the global AudioManager so sound continues after player object has been freed.
		# Might be able to change this once corpse stays in world.
		AudioManager.new_3d_sound(deathSound, global_transform.origin) 
		if(respawns > 0):
			respawns -= 1
			emit_signal("player_died", player, true) # Notifies PlayerManager that a player died and to respawn them.
		else:
			emit_signal("player_died", player) # Notifies PlayerManager that a player has died.
	else:
		updateUI()
		emit_signal("play_3d_sound", hurtSound, global_transform.origin)

# Updates the UI to the new values.
func updateUI():
	respawnCountUI.Value = respawns
	healthUI.Value = health
