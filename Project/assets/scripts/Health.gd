extends Spatial
class_name Health

export (float, 1,1000) var health = 100.0
export (float, 1,1000) var maxHealth = 100.0

signal death
signal health_change

func _ready():
	health = maxHealth

# Removes health from this object. Destroying it when below 0.
func damage(value = 0):
	if(!is_alive()):
		return

	health = max(health - value, 0)
	
	emit_signal("health_change", health / maxHealth)
	
	if(health <= 0):
		emit_signal("death")

# Adds health to this object.
func heal(value = 0):
	health = min(health + value, maxHealth)
	emit_signal("health_change", health / maxHealth)

func is_full_health():
	return true if health == maxHealth else false
	
func is_alive():
	return true if health > 0 else false
