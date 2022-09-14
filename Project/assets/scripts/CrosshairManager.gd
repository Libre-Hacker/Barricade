extends Control

enum CROSSHAIRS {NONE, HAMMER, PISTOL, AUTORIFLE}

onready var pistolCH = get_node("PistolCrosshair")
onready var hammerCH = get_node("HammerCrosshair")
onready var autorifleCH = get_node("AutoRifleCrosshair")

func _ready():
	for crosshair in get_children():
		crosshair.hide()
	pass

func switch_crosshair(type = CROSSHAIRS.NONE):
	if(type == CROSSHAIRS.NONE):
		push_warning("Crosshair switch was requested without a crosshair type. Pass a valid type to switch.")
		return
	for crosshair in get_children():
		crosshair.hide()
	if(type == CROSSHAIRS.HAMMER):
		hammerCH.show()
		return
	if(type == CROSSHAIRS.PISTOL):
		pistolCH.show()
		return
	if(type == CROSSHAIRS.AUTORIFLE):
		autorifleCH.show()
		return

func on_pistol_equipped():
	switch_crosshair(CROSSHAIRS.PISTOL)

func on_hammer_equipped():
	switch_crosshair(CROSSHAIRS.HAMMER)
	
func on_autorifle_equipped():
	switch_crosshair(CROSSHAIRS.AUTORIFLE)
	
