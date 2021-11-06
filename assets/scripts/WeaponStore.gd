extends StaticBody

export (int, 0, 9999) var price = 100
export (Resource) var weapon = null

onready var priceTag = get_node("Sprite3D/Viewport/Price")

func buy_item(player):
	var wallet = player.find_node("Wallet")
	print(wallet)
	var inventory = player.find_node("GunBelt")
	
	if(wallet.has_funds(price)):
		wallet.spend_money(price)
		print("Weapon Purchased")
		var newWeapon = weapon.instance()
		inventory.add_weapon(newWeapon)
