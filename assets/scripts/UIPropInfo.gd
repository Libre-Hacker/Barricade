extends Panel

const currentHealth = preload("res://assets/resources/current_prop_health.tres")
const maxHealth = preload("res://assets/resources/max_prop_health.tres")
const propName = preload("res://assets/resources/prop_name.tres")

onready var healthBar = get_node("VBoxContainer/TextureProgress")
onready var currentHealthLabel = get_node("VBoxContainer/HBoxContainer/CurrentHealth")
onready var maxHealthLabel = get_node("VBoxContainer/HBoxContainer/MaxHealth")
onready var propNameLabel = get_node("VBoxContainer/HBoxContainer/Name")

func _process(_delta):
	if(propName.Value == ""):
		visible = false
		return
	healthBar.max_value = maxHealth.Value
	healthBar.value = currentHealth.Value
	currentHealthLabel.text = str(currentHealth.Value)
	maxHealthLabel.text = str(maxHealth.Value)
	propNameLabel.text = propName.Value
	visible = true
		
