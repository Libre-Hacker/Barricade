extends Resource
class_name SettingsData

export var fullscreen = true
export var borderless = false
export var resolution = Vector2(1920,1080)
export var vsync = false
export var masterVolume = 1
export var musicVolume = 1
export var soundVolume = 1

export (Array) var keyBinds = [["move_forward",
				"move_backward",
				"move_left",
				"move_right",
				"jump",
				"phase",
				"interact",
				"reload",
				"rotate_prop",
				"primary_fire",
				"alt_fire",
				"next_weapon",
				"previous_weapon"],
				[KEY_W,
				KEY_S,
				KEY_A,
				KEY_D,
				KEY_SPACE,
				KEY_Z,
				KEY_E,
				KEY_R,
				KEY_ALT,
				BUTTON_LEFT,
				BUTTON_RIGHT,
				BUTTON_WHEEL_UP,
				BUTTON_WHEEL_DOWN]]
