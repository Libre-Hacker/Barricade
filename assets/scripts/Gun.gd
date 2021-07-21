extends RayCast

enum fireModes {semiAuto, fullAuto}

export(fireModes) var selectedFireMode
export(int,1,200) var maxAmmo : int # Maximum ammo the gun can hold.
export(float,1,1024) var rateOfFire : float # The weapons cycle time, in rounds/minute.
export(float,0.1,1000, 0.1) var damage : float
export(float,1,1000, 0.1) var maxRange : float
export var startLoaded : bool = true # Not sure when this will come in handy, maybe some guns start unloaded?
export var equipped : bool = false

var isReloading : bool = false
var currentAmmo : int # Number of rounds currently loaded.

var buletHitNode = preload("res://assets/scenes/BulletHit.tscn")
onready var cycleTimerNode = get_node("CycleTimer")
onready var animationPlayer = get_node("AnimationPlayer")

func _ready():
	if(startLoaded == true):
		currentAmmo = maxAmmo 
	cycleTimerNode.wait_time = 60 / rateOfFire # Convert rounds/minute into time per round.
	cast_to = Vector3(0,0,maxRange)

# Process user input.
func _input(event):
	if(Input.is_action_just_pressed("primary_fire") and selectedFireMode == fireModes.semiAuto):
		primary_fire()
	if(Input.is_action_just_pressed("reload")):
		startReload()

func _process(_delta):
	if(Input.is_action_pressed("primary_fire") and selectedFireMode == fireModes.fullAuto): # Must use _process() for full auto, or input will only be checked when another input is given.
		primary_fire()

# Fire 1 bullet, handles all logic and effects.
func primary_fire():
	if(currentAmmo <= 0 or cycleTimerNode.is_stopped() == false or equipped == false or isReloading):
		return
	currentAmmo -= 1
	get_node("AnimationPlayer").play("muzzle_flash")
	cycleTimerNode.start() # Start CycleTimer so this can't shoot before it is done.
	if(is_colliding()):
		emitImpactEffect()
		damageObject()

# Damage the object hit.
func damageObject():
	if(get_collider().is_in_group("Destructibles")):
		get_collider().call("damage", damage)

# Emits a particle effect where the bullet impacted.
func emitImpactEffect():
	var particleInstance = buletHitNode.instance()
	get_collider().add_child(particleInstance)
	particleInstance.global_transform.origin = get_collision_point()
	particleInstance.look_at(get_collision_point() + get_collision_normal(), Vector3.UP) # Causes the particle to emit perpendicular to the hit surface.
	particleInstance.emitting = true

# Starts the reload animation.
func startReload():
	if(isReloading == true or currentAmmo >= maxAmmo):
		return
	isReloading = true
	animationPlayer.stop()
	animationPlayer.play("reload")

# Called by the animator after the reload has been completed.
func endReload():
	isReloading = false
	currentAmmo = maxAmmo
