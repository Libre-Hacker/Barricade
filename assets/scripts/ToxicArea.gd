extends Area

# Object that damages anything inside every tick.

export (float,0,100) var damage = 1 # Damage delt each tick.

# Damages all bodies inside.
func damage_bodies():
	if(get_overlapping_bodies().size()>0):
		for bodies in get_overlapping_bodies():
			bodies.damage(damage)

func _on_CooldownTimer_timeout():
	damage_bodies()
