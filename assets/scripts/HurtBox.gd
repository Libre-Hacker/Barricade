extends Area

var player = null # Set by PrimaryFire node.
var damage = 0.0 # Set by PrimaryFire node.

func damageAll():
	for hitbox in get_overlapping_areas():
		if(hitbox.is_in_group("Destructibles")):
			hitbox.damage(damage, player)
