extends RayCast
# Plays a random footstep sound based on the type of surface being walked on.
# Sound plays after entity has traveled a large enough distance.

# Add a new array for each surface type.
export (Array, Resource) var tileSounds = [] # Array of tile sounds.
export (Array, Resource) var concreteSounds = [] # Array of tile sounds.

var distanceTraveled = 0.0 # How far the entity has traveled since the last step.
var threshold = 2 # Sounds plays after this distance has been traveled.

signal play_3DSound

func _process(delta):
	play_sound()

# Adds the given distance to the distanceTraveled variable.
func add_travel_distance(distance = 0.0):
	distanceTraveled += distance

# Gets the current surface type and plays the corresponding sound.
func play_sound():
	if(distanceTraveled < threshold):
		return
	
	distanceTraveled -= threshold
	print(get_collider())
	if(get_collider() == null):
		return
	if(get_collider().is_in_group("tile")):
		emit_signal("play_3DSound", tileSounds[get_random_index(tileSounds.size())], transform.origin)
	if(get_collider().is_in_group("concrete")):
		emit_signal("play_3DSound", concreteSounds[get_random_index(concreteSounds.size())], transform.origin)

# Gets a random index.
func get_random_index(arraySize):
	randomize()
	return round(rand_range(0, arraySize -1))
