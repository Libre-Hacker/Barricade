extends RigidBody

export var speed = 1.0
export (Resource) var bounceSound
export var ejectDirection = Vector3.ZERO

func _ready():
	set_as_toplevel(true)
	apply_central_impulse(transform.basis.xform(ejectDirection.normalized() * speed))


func _on_collision(body):
	AudioManager.new_3d_sound(bounceSound, global_transform.origin, 0.0, 2)
	queue_free()
