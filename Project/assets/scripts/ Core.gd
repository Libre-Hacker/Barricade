extends StaticBody
# Handles state of prop, we do not use a hit box to detect attacks because most
# props will have unique collision boxes, so the rigid body captures the attacks
# and forwards them to the health node.

export (String) var realName = "Core" # The name of the prop, for UI use.

func select_core():
	get_node("MeshInstance").get_surface_material(0).flags_transparent = false
	GameManager.coreManager.set_core(self)
