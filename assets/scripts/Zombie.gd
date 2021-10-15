extends KinematicBody

export (float, 0, 1000) var health
var path = []
var path_node = 0

export var speed = 4
onready var nav = find_parent("Navigation")
signal destroyed

func _ready():
	speed *= rand_range(0.8,1.2)

func _unhandled_input(event):
	if(event.is_action_pressed("TEST_KILL")):
		emit_signal("destroyed")
		self.queue_free()

func _physics_process(delta):
	if(path_node < path.size()):
		var direction = (path[path_node] - global_transform.origin)
		if(direction.length() < 0.6):
			path_node += 1
		else:
			look_at(path[path_node], Vector3.UP)
			move_and_slide(direction.normalized() * speed, Vector3.UP, true, 1)
			rotation.x = 0
			rotation.z = 0

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _on_Timer_timeout():
	move_to(get_tree().get_root().find_node("FPSPlayer", true, false).global_transform.origin)


# Flips damage value to negative.
func damage(value : float):
	if(health - value <= 0):
		print(name, " is destroyed.")
		emit_signal("destroyed")
		self.queue_free()
	else:
		health -= value
		print(name, " health = ", health)


func _on_HitBox_hit(damage):
	damage(damage)
