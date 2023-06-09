extends RigidBody

export (Resource) var hitSound
export (Resource) var statusEffect

var damage = 5

var speed = 1

func _ready():
	set_as_toplevel(true)

func shoot(direction = Vector3.ZERO):
	apply_central_impulse(direction * speed)

func _on_area_hit(area):
	if(area.is_in_group("Players") or area.is_in_group("Props")):
		area.damage({value = damage, entity = null, statusEffect = statusEffect})
	AudioManager.new_3d_sound(hitSound, global_transform.origin, 0.0, 2)
	queue_free()
