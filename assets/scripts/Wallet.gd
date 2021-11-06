extends Spatial

# Stores money, and handles receiving and spending it.

const uiMoney = preload("res://assets/resources/money.tres")
export (int, 0, 100000) var money # Amount of money this player owns.

func _ready():
	uiMoney.Value = money
	
# Adds money to the wallet.
func add_money(value):
	money += value
	uiMoney.Value = money
	print("Money = ", money)

# Removes money from the wallet.
func spend_money(value):
	if(money - value >= 0):
		money -= value
		uiMoney.Value = money
		print("Purchase made. New balace = ", money)
	else:
		print("Insufficent funds.")

func has_funds(value):
	if(value <= money):
		return true
	else:
		return false
