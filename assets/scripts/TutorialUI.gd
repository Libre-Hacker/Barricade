extends Control

var hammerEnabled = false
var gunEnabled = false
var propEnabled = false

onready var enabled = Settings.settings.miscSettings[1][0]


func _process(delta):
	if(Settings.settings.miscSettings[1][0]):
		enabled = true
		show()
	else:
		enabled = false
		hide()


func toggle_gun_controls():
	if(gunEnabled):
		get_node("VBoxContainer/Reload").hide()
		get_node("VBoxContainer/Shoot").hide()
		gunEnabled = false
	else:
		get_node("VBoxContainer/Reload").show()
		get_node("VBoxContainer/Shoot").show()
		gunEnabled = true


func toggle_hammer_controls():
	if(hammerEnabled):
		get_node("VBoxContainer/Nail").hide()
		get_node("VBoxContainer/Repair").hide()
		get_node("VBoxContainer/RemoveNail").hide()
		hammerEnabled = false
	else:
		get_node("VBoxContainer/Nail").show()
		get_node("VBoxContainer/Repair").show()
		get_node("VBoxContainer/RemoveNail").show()
		hammerEnabled = true


func toggle_prop_controls():
	if(propEnabled):
		get_node("VBoxContainer/RotateProps").hide()
		get_node("VBoxContainer/HoldProp").hide()
		propEnabled = false
	else:
		get_node("VBoxContainer/RotateProps").show()
		get_node("VBoxContainer/HoldProp").show()
		propEnabled = true
