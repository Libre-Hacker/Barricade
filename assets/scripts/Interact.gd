extends RayCast
# A raycast that detects useable objects that the player can interact with using input.
# Also handles manipulation of props.

export (float, 0, 20, 0.1) var maxPropHoldDistance = 4.0 # Held prop further than this value will be dropped.

var propInUse : Node # The prop currently held by the player.
var mouseX
var mouseY

signal prop_picked_up
signal prop_interacted_with
signal show_ui
signal hide_ui

onready var player = find_parent(str(get_network_master()))


func _unhandled_input(event):
	if(is_network_master() == false):
		return
	# Must use Input to check if rotating prop, because the event is researved for mouse motion.
	if(event is InputEventMouseMotion and Input.is_action_pressed("rotate_prop") and is_holding_prop()):
		mouseX = event.relative.x
		mouseY = event.relative.y
		get_tree().get_root().set_input_as_handled()
		rotate_prop(mouseX,mouseY)
		return
	else:
		mouseX = 0
		mouseY = 0
	if(is_holding_prop() and Input.is_action_pressed("hold_prop_in_place")):
		propInUse.holdInPlace = true
	elif(is_holding_prop()):
		propInUse.holdInPlace = false
	if(event.is_action_pressed("interact")):
		interact()
		get_tree().get_root().set_input_as_handled()

func _physics_process(_delta):
	is_prop_in_range()
	show_ui_prompt()

func show_ui_prompt():
	if(is_colliding() == false):
		emit_signal("hide_ui")
		return
	if(get_collider().is_in_group("Interactables") == false):
		emit_signal("hide_ui")
		return
	emit_signal("show_ui", get_collider(), player)

# Sets the class variables and calls the hit objects "interact" function.
func interact():
	if(is_holding_prop()):
		drop_prop()
		return

	if(is_colliding() == false):
		return

	if(get_collider().is_in_group("Interactables")):
		get_collider().buy_item(get_owner())
		return
	
	if(get_collider().is_in_group("Core")):
		pickup_prop()
		return

	if(get_collider().is_in_group("Props") and get_collider().isNailed == false):
		pickup_prop()

# Gathers mouse input and sends it to the prop in use to be rotated.
func rotate_prop(x, y):
	var mouseMovement = Vector3(x, y, 0) * 0.1
	propInUse.mouse_rotate(mouseMovement)

# Sets the targeted prop to follow the assigned point.
func pickup_prop():
	propInUse = get_collider()
	if(propInUse.pickup(get_node("HoldPoint"), player)):
		propInUse.connect("dropped", self, "drop_prop")
		propInUse.connect("tree_exiting", self, "drop_prop")
		enabled = false
		emit_signal("prop_interacted_with")
		emit_signal("prop_picked_up", 0)
		return
	propInUse = null

# Tells the held prop to stop following the assigned point.
func drop_prop():
	propInUse.drop()
	propInUse.disconnect("dropped", self, "drop_prop")
	propInUse.disconnect("tree_exiting", self, "drop_prop")
	propInUse = null
	enabled = true
	emit_signal("prop_interacted_with")

# Checks if the propInUse variable is null.
func is_holding_prop():
	if(propInUse != null):
		return true
	else:
		return false

# Checks if the held prop is in range, if not drops the prop.
func is_prop_in_range():
	if(is_holding_prop() and global_transform.origin.distance_to(propInUse.transform.origin) > maxPropHoldDistance):
		drop_prop()

