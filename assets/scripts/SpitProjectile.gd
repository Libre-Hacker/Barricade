extends RigidBody

export (Resource) var hitSound
export (Resource) var statusEffect

var damage = 5
var spread = 0.2

var speed = 1

func _ready():
	set_as_toplevel(true)

func shoot():
	var randomness = Vector3(rand_range(-spread,spread), rand_range(0, spread), 0)
	apply_central_impulse((-transform.basis.z * speed) + randomness)

func _on_area_hit(area):
	if(area.is_in_group("Players") or area.is_in_group("Props")):
		area.damage(damage, self, Vector3.ZERO, statusEffect)
	AudioManager.new_3d_sound(hitSound, global_transform.origin, 0.0, 2)
	queue_free()
