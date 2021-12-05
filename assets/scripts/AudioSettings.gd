extends Tabs

signal setting_changed

onready var masterSlider = get_node("VBoxContainer/HBoxContainer/MasterSlider")
onready var musicSlider = get_node("VBoxContainer/HBoxContainer_2/MusicSlider")
onready var soundSlider = get_node("VBoxContainer/HBoxContainer_3/SoundSlider")

func _ready():
	load_settings()

func load_settings():
	masterSlider.value = Settings.settings.masterVolume
	musicSlider.value = Settings.settings.musicVolume
	soundSlider.value = Settings.settings.soundVolume

func _on_Slider_value_changed(_value):
	AudioServer.set_bus_volume_db(0, linear2db(masterSlider.value))
	AudioServer.set_bus_volume_db(1, linear2db(musicSlider.value))
	AudioServer.set_bus_volume_db(2, linear2db(soundSlider.value))
	Settings.settings.masterVolume = masterSlider.value
	Settings.settings.musicVolume = musicSlider.value
	Settings.settings.soundVolume = soundSlider.value
	emit_signal("setting_changed")
