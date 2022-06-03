extends AnimationPlayer
# Base Class for Animation Player nodes.

export var returnToDefaultAnimation = false
export var defaultAnimation = "" # Default animation to play after all animations.

# Check for variable errors.
func _ready():
	if(returnToDefaultAnimation and defaultAnimation == ""):
		print("ERROR: Default animation isn't defined.")

# Plays the signaled animation
func _on_change_animation(animationName, interupt = false):
	if(has_animation(animationName) == false):
		return
	if(current_animation == animationName and interupt == false):
		return
	if(is_playing() and interupt == false):
		yield(self, "animation_finished")
	if(interupt == true):
		stop(true)
	play(animationName)


func has_animation(animationName):
	for animation in get_animation_list():
		if(animation == animationName):
			return true
	return false



# Plays the default animation if set.
func _on_animation_finished(_anim_name):
	if(returnToDefaultAnimation):
		play(defaultAnimation)

func stop_animating():
	stop()
