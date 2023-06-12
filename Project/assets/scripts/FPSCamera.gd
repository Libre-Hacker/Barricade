extends Camera
# Converts mouse input into camera rotation. Horizontal rotation rotates the player object.

export var mounseSensitivity : float = 0.1
export(float, 0, 90, 0.1) var maxLookUp : float= 90
export(float, -90, 0, 0.1) var minLookDown : float = -90

onready var player = get_parent()
onready var interactionRayCast = get_node("Interaction")

# Gets mouse input and calls corresponding function.
func _unhandled_input(event):
	if(is_network_master() == false):
		return
	if(GameManager.isPaused): # Disable input while game is paused.
		return
		
	# Disable input while rotating props.
	if(event.is_action_pressed("rotate_prop") and interactionRayCast.is_holding_prop()):
		return
		
	if(event is InputEventMouseMotion):
		get_tree().get_root().set_input_as_handled()
		VerticalLook(event.relative.y)
		HorizontalLook(event.relative.x)


# Rotates this object around the x-axis to look up and down.
func VerticalLook(mouseMovement):
	rotation_degrees.x -= mouseMovement * mounseSensitivity
	# Clamp our vertical rotation so we can't go upside down.
	rotation_degrees.x = clamp(rotation_degrees.x, minLookDown, maxLookUp)

# Rotates the player object on the y-axis with mouse input.
func HorizontalLook(mouseMovement):
	player.rotation_degrees.y -= mouseMovement * mounseSensitivity 
