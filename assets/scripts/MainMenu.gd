extends CanvasLayer

signal level_changed
signal start_game

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
# warning-ignore:return_value_discarded
	connect("start_game", get_tree().get_root().get_node("GameManager"), "_on_start_game")

func _on_Options_button_down():
	emit_signal("level_changed", "OptionsMenu")

func _on_Start_button_down():
	emit_signal("start_game")
