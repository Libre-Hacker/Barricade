extends Health
# Inherits the health class and extends it for use with players.

export (Resource) var hurtSound
export (Resource) var deathSound

signal play_3d_sound
signal player_died

onready var player = get_parent()
onready var healthUI = get_node("HealthUI")

# Set health to max health, and update the players UI.
func _ready():
	health = maxHealth
	updateUI()

func _process(_delta):
	updateUI()

# Recevied from the hitbox that was hit. Removes health from the base class.
func _on_hitbox_collision(damageReceived, attacker):
	.damage(damageReceived)
	is_destroyed()

# Overrides the base function for player specific uses. Handles respawning and audio.
func is_destroyed():
	if(health <= 0):
		#print(player.name, " is destroyed.") # For debugging
		
		# Play this on the global AudioManager so sound continues after player object has been freed.
		# Might be able to change this once corpse stays in world.
		AudioManager.new_3d_sound(deathSound, global_transform.origin) 
		emit_signal("player_died", player) # Notifies PlayerManager that a player has died.
	else:
		updateUI()
		emit_signal("play_3d_sound", hurtSound)

# Updates the UI to the new values.
func updateUI():
	healthUI.update_health(health)
