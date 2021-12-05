extends RayCast

export (Array, Resource) var tileSounds = []

var distanceTraveled = 0.0
var threshold = 2

func add_travel_distance(distance = 0.0):
	distanceTraveled += distance
	
func _process(delta):
	if(distanceTraveled > threshold):
		play_sound()
		distanceTraveled -= threshold

func play_sound():
	if(get_collider() == null):
		return
	if(get_collider().is_in_group("tile")):
		var newSound = load("res://assets/scenes/OneTimeAudio3D.tscn").instance()
		newSound.bus = "Sound"
		var sound = tileSounds[get_random_index(tileSounds.size())]
		newSound.set_stream(sound)
		add_child(newSound)

func get_random_index(arraySize):
	randomize()
	return round(rand_range(0, arraySize -1))
