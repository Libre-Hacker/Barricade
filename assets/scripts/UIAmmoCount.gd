extends Panel

onready var loadedAmmoLabel = get_node("LoadedAmmo")
onready var reserveAmmoLabel = get_node("ReserveAmmo")

func on_ammo_changed(loadedAmmo, reserveAmmo):
	loadedAmmoLabel.text = str(loadedAmmo)
	reserveAmmoLabel.text = str(reserveAmmo)
