extends MeshInstance

func _on_Health_updateDamageIndicator(value):
	var material = get_surface_material(0)
	material.albedo_color = Color.from_hsv(0, 1 - value, 1, 0.8)
	set_surface_material(0, material)
