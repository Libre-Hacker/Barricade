extends Camera

var mounseSensitivity = 0.1
export(NodePath) var player

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		VerticalLook(event.relative.y)
		HorizontalLook(event.relative.x)

func VerticalLook(mouseMovement):
	rotation_degrees.x -= mouseMovement * mounseSensitivity
	rotation_degrees.x = clamp(rotation_degrees.x, -90, 90)

func HorizontalLook(mouseMovement):
	if get_node(player) != null:
		get_node(player).rotation_degrees.y -= mouseMovement * mounseSensitivity
	
