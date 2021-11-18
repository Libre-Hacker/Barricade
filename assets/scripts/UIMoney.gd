extends Panel

const money = preload("res://assets/resources/money.tres")
onready var moneyLabel = get_node("HBoxContainer/Money")


func _process(_delta):
	moneyLabel.text = str(money.Value)

