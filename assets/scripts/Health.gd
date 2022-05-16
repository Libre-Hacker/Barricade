extends Spatial
class_name Health

export (float, 1,1000) var health = 100.0
export (float, 1,1000) var maxHealth = 100.0

signal health_changed
signal destroyed

func _ready():
	health = maxHealth

# Removes health from this object. Destroying it when below 0.
func damage(value = 0):
	if(health <= 0):
		#print("health is already depleted")
		return
	health -= value
	#print(get_parent().name, " health = ", health)

# Adds health to this object.
func heal(value = 0):
	if(health == maxHealth):
		return false
	if(health + value > maxHealth):
		health = maxHealth
	else:
		health += value
	#print(get_parent().name, " health = ", health)
	return true
