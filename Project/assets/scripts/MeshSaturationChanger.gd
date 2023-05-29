extends MeshInstance

var defHue = get_surface_material(0).albedo_color.h

# Sets albedo saturation to the given %.
func change_saturation(value):
	var material = get_surface_material(0)
	material.albedo_color = Color.from_hsv(0, 1 - value, 1, 0.8)
	set_surface_material(0, material)

# Sets albedo hue to the given % of the default hue.
func change_hue(value):
	var material = get_surface_material(0)
	material.albedo_color = Color.from_hsv(value * defHue, 1, 1, 0.8)
	set_surface_material(0, material)
