extends RigidBody

var damage = 5
var shot = false
var spread = 0.2

var speed = 1

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	if(shot == false):
		var randomness = Vector3(rand_range(-spread,spread), rand_range(0,spread + 0.2), 0)
		apply_central_impulse((-transform.basis.z * speed) + randomness)
		shot = true

func _on_area_hit(area):
	if(area.is_in_group("Players") or area.is_in_group("Props")):
		area.damage(damage)
	queue_free()
