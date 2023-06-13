extends RayCast
# Functions to detect a prop, and pass its stats to a UI widget.

const currentHealth = preload("res://assets/resources/current_prop_health.tres")
const maxHealth = preload("res://assets/resources/max_prop_health.tres")
const propName = preload("res://assets/resources/prop_name.tres")

onready var propInfo = get_node("PropInfo")

func _physics_process(_delta):
	if(GameManager.isPaused):
		return
	gather_prop_info()

func gather_prop_info():
	if(is_colliding()):
		if(get_collider().is_in_group("Props") or get_collider().is_in_group("Core")):
			propInfo.show()
			propInfo.update_ui(get_collider().realName, get_collider().get_node("Health").health,get_collider().get_node("Health").maxHealth )
			return
	propInfo.hide()
