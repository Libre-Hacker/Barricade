extends StaticBody

# Sells the interacting player the item for sale if the player doesn't already
# own the weapon, and they have enough funds. Weapon for sale needs to be defined
# in the inspector.

export (int, 0, 9999) var price = 100 # the price to buy the weapon.
export (int, 0, 999) var primaryAmmo = 0
export (int, 0, 999) var alternativeAmmo = 0
export (int, 0, 9999) var ammoPrice
export (Resource) var weapon = null # The weapon for sale.

onready var priceTag = get_node("Sprite3D/Viewport/Price")

func _ready():
	priceTag.text = str(price)

# Called by the players interact script. Spawns a new weapon and gives it to the player
# if the criteria is met.
func buy_item(player):
	var wallet = player.find_node("Wallet")
	var inventory = player.find_node("GunBelt")
	
	var newWeapon = weapon.instance()
	for item in inventory.get_children():
		if(item.name == newWeapon.name):
			if(wallet.has_funds(ammoPrice)):
				wallet.spend_money(ammoPrice)
				item.add_ammo(primaryAmmo, alternativeAmmo)
				print("Ammo Purcahsed")
			return
			
	if(wallet.has_funds(price)):
		wallet.spend_money(price)
		print("Weapon Purchased")
		inventory.add_weapon(newWeapon)
