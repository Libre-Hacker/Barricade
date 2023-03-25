extends StaticBody

export (int, 0, 9999) var price = 100 # Price to buy the door.
export (Resource) var purchaseSound
export (Resource) var insufficientFundsSound

signal on_purchase

func _ready():
	pass # Replace with function body.

func buy_item(player):
	var wallet = player.find_node("Wallet")
	if (wallet == null):
		return

	# Attempt to buy the weapon and add it to the players inventory.
	if(wallet.spend_money(price)):
		get_node("AudioManager").new_3d_sound(purchaseSound, Vector3.ZERO, 0, 5)
		emit_signal("on_purchase")
		queue_free()
	else:
		get_node("AudioManager").new_3d_sound(insufficientFundsSound, Vector3.ZERO, 0, 5)
	pass
