extends RayCast
# Functions to detect a prop, and pass its stats to a UI widget.

const currentHealth = preload("res://assets/resources/current_prop_health.tres")
const maxHealth = preload("res://assets/resources/max_prop_health.tres")
const propName = preload("res://assets/resources/prop_name.tres")

func gather_prop_info():
	if(is_colliding() and get_collider().is_in_group("Props")):
		update_ui(get_collider())
	else:
		propName.Value = ""

func update_ui(prop):
	currentHealth.Value = prop.get_node("Health").health
	maxHealth.Value = prop.get_node("Health").maxHealth
	propName.Value = prop.realName
