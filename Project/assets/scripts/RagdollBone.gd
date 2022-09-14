extends PhysicalBone

func add_force(hitForce = Vector3.ZERO):
	apply_central_impulse(hitForce)
