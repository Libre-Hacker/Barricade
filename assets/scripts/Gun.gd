extends RayCast

enum fireModes {semiAuto, fullAuto}

export(fireModes) var selectedFireMode
export(int,1,200) var ammoCapacity : int # Maximum ammo the gun can hold.
export(int,1,1000) var maxReserveAmmo : int # Maximum ammo held in reserve.
export(float,1,1024) var rateOfFire : float # The weapons cycle time, in rounds/minute.
export(float,0.1,1000, 0.1) var damage : float
export(float,1,1000, 0.1) var maxRange : float
export var startLoaded : bool = true # Not sure when this will come in handy, maybe some guns start unloaded?

var isReloading : bool = false
var currentAmmo : int # Number of rounds currently loaded.
export var reserveAmmo : int # Export for now until buying ammo is implemented.
signal ammo_changed
signal play_animation(animationName)

var buletHitParticleNode = preload("res://assets/scenes/BulletHitParticle.tscn")
onready var cooldownTimer = get_node("Cooldown")
onready var animationPlayer = get_node("AnimationPlayer")

func _ready():
	connect("ammo_changed", get_node("../../../HUD/AmmoCount"), "on_ammo_changed")
	if(startLoaded == true):
		currentAmmo = ammoCapacity 
	cooldownTimer.wait_time = 60 / rateOfFire # Convert rounds/minute into time per round.
	cast_to = Vector3(0,0,maxRange)

# Process user input.
func _unhandled_input(event):
	if(event.is_action_pressed("primary_fire") and selectedFireMode == fireModes.semiAuto):
		primary_fire()
		get_tree().get_root().set_input_as_handled()
	if(event.is_action_pressed("reload")):
		startReload()
		get_tree().get_root().set_input_as_handled()

func _process(_delta):
	if(Input.is_action_pressed("primary_fire") and selectedFireMode == fireModes.fullAuto): # Must use _process() for full auto, or input will only be checked when another input is given.
		primary_fire()

# Fire 1 bullet, handles all logic and effects.
func primary_fire():
	if(currentAmmo <= 0 or cooldownTimer.is_stopped() == false or isReloading):
		return
	currentAmmo -= 1
	updateUI()
	emit_signal("play_animation", "primary_fire")
	cooldownTimer.start() # Start CycleTimer so this can't shoot before it is done.

	if(is_colliding()):
		emitImpactEffect()
		damageObject()

# Damage the object hit.
func damageObject():
	if(get_collider().is_in_group("Destructibles")):
		get_collider().call("damage", damage)

# Emits a particle effect where the bullet impacted.
func emitImpactEffect():
	var particleInstance = buletHitParticleNode.instance()
	get_collider().add_child(particleInstance)
	particleInstance.global_transform.origin = get_collision_point()
	particleInstance.look_at(get_collision_point() + get_collision_normal(), Vector3.UP) # Causes the particle to emit perpendicular to the hit surface.
	particleInstance.emitting = true

# Starts the reload animation.
func startReload():
	if(isReloading == true or currentAmmo >= ammoCapacity or reserveAmmo <= 0):
		return
	isReloading = true
	emit_signal("play_animation", "reload")

# Called by the animator after the reload has been completed.
func endReload():
	isReloading = false
	var ammoToReload : int
	if(reserveAmmo < ammoCapacity):
		ammoToReload = reserveAmmo
	else:
		ammoToReload = ammoCapacity - currentAmmo
	
	currentAmmo += ammoToReload
	reserveAmmo -= ammoToReload
	updateUI()

func updateUI():
	emit_signal("ammo_changed", currentAmmo, reserveAmmo)
