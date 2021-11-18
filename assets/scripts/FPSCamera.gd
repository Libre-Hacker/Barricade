extends Camera

export var mounseSensitivity : float = 0.1
export(float, 0, 90, 0.1) var maxLookUp : float= 90
export(float, -90, 0, 0.1) var minLookDown : float = -90
export(NodePath) var playerNodePath : NodePath

const menuOpened = preload("res://assets/resources/menu_opened.tres")

onready var player = get_node(playerNodePath)
onready var interactionRayCast = get_node("InteractionRayCast")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Lock mouse to game screen.
	pass

# Gets mouse input and calls corresponding function.
func _unhandled_input(event):
	if(menuOpened.Value):
		return
	if(interactionRayCast.isInteracting and event.is_action_pressed("rotate_prop")):
		return
	if(event is InputEventMouseMotion):
		get_tree().get_root().set_input_as_handled()
		VerticalLook(event.relative.y)
		HorizontalLook(event.relative.x)

# Rotates this object around the x-axis
func VerticalLook(mouseMovement):
	rotation_degrees.x -= mouseMovement * mounseSensitivity
	rotation_degrees.x = clamp(rotation_degrees.x, minLookDown, maxLookUp) # Clamp our vertical rotation so we can't go upside down

# Rotates an assigned object on the y-axis with mouse input.
func HorizontalLook(mouseMovement):
	# Debugging
	if player != null: # Allows the game to run without breaking.
		player.rotation_degrees.y -= mouseMovement * mounseSensitivity 
	else:
		push_warning("No node assigned, did you forget to assign it in the inspector?")
