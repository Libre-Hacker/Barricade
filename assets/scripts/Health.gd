extends Spatial

export (float, 1,1000) var health = 100.0
export (float, 1,1000) var maxHealth = 100.0

signal health_changed
signal destroyed

func _ready():
	health = maxHealth

# FOR TESTING ONLY, DELETE WHEN READY!
func _unhandled_input(event):
	if(event.is_action_pressed("TEST_KILL")):
		print("kill all")
		damage(null, 100000)

# Removes health from this object. Destroying it when below 0.
func damage(attacker = null, value = 0):
	if(health - value <= 0):
		print(name, " is destroyed.")
		# Use health instead of damage because damage may be greater than health.
		var percentChange = health / maxHealth 
		emit_signal("health_changed", attacker, percentChange)
		emit_signal("destroyed") # Emit signal to be qued for respawn
		get_parent().queue_free()
	else:
		health -= value
		print(name, " health = ", health)
		var percentChange = value / maxHealth
		emit_signal("health_changed", attacker, percentChange)

func _on_hitbox_collision(attackingEntity, damageReceived):
	damage(attackingEntity, damageReceived)
