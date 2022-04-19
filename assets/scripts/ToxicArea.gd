extends Area

# Object that damages anything inside every tick.

export (float,0,100) var damage = 1 # Damage delt each tick.

# Damages all bodies inside.
func damage_bodies():
	if(get_overlapping_areas().size()>0):
		for entities in get_overlapping_areas():
			entities.damage(damage, null)

func _on_CooldownTimer_timeout():
	damage_bodies()
