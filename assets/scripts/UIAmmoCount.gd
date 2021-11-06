extends Panel

const loadedAmmo = preload("res://assets/resources/loaded_ammo.tres")
const reserveAmmo = preload("res://assets/resources/reserve_ammo.tres")
onready var loadedAmmoLabel = get_node("HBoxContainer/LoadedAmmo")
onready var reserveAmmoLabel = get_node("HBoxContainer/ReserveAmmo")

func _process(_delta):
	loadedAmmoLabel.text = str(loadedAmmo.Value)
	reserveAmmoLabel.text = str(reserveAmmo.Value)

