extends Spatial
class_name Health

export (float, 1,1000) var health = 100.0
export (float, 1,1000) var maxHealth = 100.0

signal destroyed

func _ready():
	health = maxHealth

# Removes health from this object. Destroying it when below 0.
func damage(value = 0):
	health = max(health - value, 0)

# Adds health to this object.
func heal(value = 0):
	health = min(health + value, maxHealth)

func is_full_health():
	return true if health == maxHealth else false
	
func is_dead():
	return false if health > 0 else true
