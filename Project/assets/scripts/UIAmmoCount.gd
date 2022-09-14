extends Panel
# Displays the players ammo quantities.

onready var loadedAmmoLabel = get_node("HBoxContainer/LoadedAmmo")
onready var reserveAmmoLabel = get_node("HBoxContainer/ReserveAmmo")

func update_ui(loadedAmmo, reserveAmmo):
	loadedAmmoLabel.text = str(loadedAmmo)
	reserveAmmoLabel.text = str(reserveAmmo)
