extends Spatial
class_name Health

export (float, 1,1000) sync var health = 100.0
export (float, 1,1000) var maxHealth = 100.0

signal health_changed
signal destroyed

func _ready():
	health = maxHealth

# Removes health from this object. Destroying it when below 0.
func damage(value = 0):
	if(health <= 0):
		return
	rset("health", health - value)
	emit_signal("health_changed", health/maxHealth)

# Adds health to this object.
func heal(value = 0):
	if(health == maxHealth):
		return false
	if(health + value > maxHealth):
		rset("health", maxHealth)
	else:
		rset("health", health + value)
	emit_signal("health_changed", health/maxHealth)
	return true
