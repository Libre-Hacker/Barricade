extends RayCast

const currentHealth = preload("res://assets/resources/current_prop_health.tres")
const maxHealth = preload("res://assets/resources/max_prop_health.tres")
const propName = preload("res://assets/resources/prop_name.tres")

func _physics_process(_delta):
	update_ui()

func update_ui(forceStop = false):
	if(is_colliding() == false or forceStop):
		propName.Value = ""
		return
	var prop = get_collider()
	currentHealth.Value = prop.health
	maxHealth.Value = prop.maxHealth
	propName.Value = prop.realName
