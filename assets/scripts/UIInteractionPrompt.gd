extends Label
# Shows interaction details as text.

func show_text(interactable = null, player = null):
	update_text(interactable, player)
	show()

func update_text(interactable, player):
	if(interactable.is_in_group("VendingMachine")):
		if(interactable.is_weapon_owned(player) == false):
			text = "Press " + InputMap.get_action_list("interact")[0].as_text() + " to purchase " + interactable.newWeapon.name + " for $" + String(interactable.price)
			text = text.to_upper()
		else:
			text = "Press " + InputMap.get_action_list("interact")[0].as_text() + " to purchase ammo for $" + String(interactable.ammoPrice)
			text = text.to_upper()

func hide_text():
	hide()
