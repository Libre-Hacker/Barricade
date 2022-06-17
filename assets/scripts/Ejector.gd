extends Spatial

export (Resource) var primaryShell
export (Resource) var secondaryShell

func eject_shell():
	var newProjectile = primaryShell.instance()
	add_child(newProjectile)
