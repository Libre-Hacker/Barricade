extends Panel

onready var loadedAmmoLabel = get_node("LoadedAmmo")
onready var reserveAmmoLabel = get_node("ReserveAmmo")

func _on_SemiAutoRifle_ammo_changed(value):
	loadedAmmoLabel.text = str(value)


func _on_Pistol_ammo_changed(value):
	loadedAmmoLabel.text = str(value)


func _on_PistolNew_ammo_changed(value) -> void:
	pass # Replace with function body.
