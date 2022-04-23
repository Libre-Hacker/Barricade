extends Camera
# Converts mouse input into camera rotation. Horizontal rotation rotates the player object.

export var mounseSensitivity : float = 0.1
export(float, 0, 90, 0.1) var maxLookUp : float= 90
export(float, -90, 0, 0.1) var minLookDown : float = -90
export(NodePath) var playerNodePath : NodePath

onready var player = get_node(playerNodePath)
onready var interactionRayCast = get_node("Interaction")
onready var gunCamera = get_parent().get_node("ViewportContainer/Viewport/GunCamera")


func _ready():
	get_viewport().connect("size_changed", self, "_on_window_resize")
	gunCamera.set_environment(get_environment())

func _on_window_resize():
	get_parent().get_node("ViewportContainer/Viewport").size = get_viewport().size

func _process(delta):
	gunCamera.global_transform = global_transform

# Gets mouse input and calls corresponding function.
func _unhandled_input(event):
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
