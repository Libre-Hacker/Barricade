extends RayCast

var isInteracting : bool = false
var usingNode : Node

export (float, 0, 20, 0.1) var maxInteractionDistance : float = 4
export (float, 0.01, 1, 0.01) var rotateSensitivity : float = 0.1
export var ignoreOwner : bool = false
export (Array, NodePath) var nodeExceptions

func _ready():
	setExceptions()

func _process(_delta):
	endInteract() # Call this first or we will immediately end the interaction.
	startInteract()

func _unhandled_input(event):
	if (event is InputEventMouseMotion and Input.is_action_pressed("rotate_prop")):
		mouseRotate(event.relative.x, event.relative.y)
		get_tree().get_root().set_input_as_handled()

func mouseRotate(mouseX, mouseY):
	if(isInteracting == false):
		return
	if(Input.is_action_pressed("rotate_prop")):
		var mouseMovement = Vector3(mouseX * rotateSensitivity, mouseY * rotateSensitivity, 0)
		mouseMovement.normalized()
		usingNode.call("rotateProp", mouseMovement)

# Sets any raycast exceptions set via the inspector.
func setExceptions():
	if(ignoreOwner):
		add_exception(get_owner())
	for node in nodeExceptions:
		add_exception(node)
	
# Sets the class variables and calls the hit objects "interact" function.
func startInteract():
	if(is_colliding() == false):
		return
	if(get_collider().is_in_group("Props") and Input.is_action_just_pressed("interact")):
		usingNode = get_collider()
		usingNode.call("pickup", get_node("HoldPoint"))
		isInteracting = true
		enabled = false

# Resets our variables to their default
func endInteract():
	if(isInteracting == false):
		return
	if(Input.is_action_just_pressed("interact") or global_transform.origin.distance_to(usingNode.transform.origin) > maxInteractionDistance):
		usingNode.call("drop")
		usingNode = null
		isInteracting = false
		enabled = true

