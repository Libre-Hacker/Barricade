extends Panel
# Displays the health bar of the assigned prop.

onready var healthBar = get_node("VBoxContainer/TextureProgress")
onready var currentHealthLabel = get_node("VBoxContainer/HBoxContainer/CurrentHealth")
onready var maxHealthLabel = get_node("VBoxContainer/HBoxContainer/MaxHealth")
onready var propNameLabel = get_node("VBoxContainer/HBoxContainer/Name")

func _process(_delta):
	if(GameManager.isPaused or is_network_master() == false):
		self.hide()
	else:
		self.show()

func update_ui(propName = "", propHealth = 0.0, propMaxHealth = 0.0):
	healthBar.max_value = propMaxHealth
	healthBar.value = propHealth
	currentHealthLabel.text = str(propHealth)
	maxHealthLabel.text = str(propMaxHealth)
	propNameLabel.text = propName
