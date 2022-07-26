extends StaticBody
# Sells the interacting player the item for sale if the player doesn't already
# own the weapon, and they have enough funds. Weapon for sale needs to be defined
# in the inspector.

export (int, 0, 9999) var price = 100 # Price to buy the weapon.
export (int, 0, 999) var primaryAmmo = 0 # How much primary ammo is given upon purchase.
export (int, 0, 999) var alternateAmmo = 0 # How much alternate ammo is given upon purchase.
export (int, 0, 9999) var ammoPrice = 100 # Price to buy ammo.
export (Resource) var weapon = null # The weapon for sale.
export (Resource) var purchaseSound
export (Resource) var insufficientFundsSound

onready var newWeapon = weapon.instance()

# Called by the players interact script. Spawns a new weapon and gives it to the player.
func buy_item(player):
	var wallet = player.find_node("Wallet")
	var inventory = player.find_node("GunBelt")
	if (wallet == null or inventory == null):
		return

	# Must check if player already owns weapon first. If they do, attempt to buy ammo.
	for item in inventory.get_children():
		if(item.name == newWeapon.name):
			if(item.has_max_ammo() == false and wallet.spend_money(ammoPrice)):
				item.add_ammo(primaryAmmo, alternateAmmo)
				get_node("AudioManager").new_3d_sound(purchaseSound, Vector3.ZERO, 0, 5)
			else:
				get_node("AudioManager").new_3d_sound(insufficientFundsSound, Vector3.ZERO, 0, 5)
			return

	# Attempt to buy the weapon and add it to the players inventory.
	if(wallet.spend_money(price)):
		inventory.add_weapon(newWeapon)
		get_node("AudioManager").new_3d_sound(purchaseSound, Vector3.ZERO, 0, 5)
	else:
		get_node("AudioManager").new_3d_sound(insufficientFundsSound, Vector3.ZERO, 0, 5)

func is_weapon_owned(player):
	var inventory = player.find_node("GunBelt")
	if (inventory == null):
		return false
	
	for item in inventory.get_children():
		if(item.name == newWeapon.name):
			return true
	
	return false
