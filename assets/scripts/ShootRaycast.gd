extends RayCast
# Manages ammo, and fires a raycast that damages objects.

export(int,1,200) var ammoCapacity : int # Maximum ammo the gun can hold.
export var reserveAmmo : int # Export for now until buying ammo is implemented.
export(int,1,1000) var maxReserveAmmo : int # Maximum ammo held in reserve.
export(float,1,1024) var rateOfFire : float # The weapons cycle time, in rounds/minute.
export(float,0.1,1000, 0.1) var damage : float # How much damage each bullet causes.
export(float,1,1000, 0.1) var maxRange : float # Maximum range of the weapon.
export (Resource) var fireSound
var isReloading : bool = false

signal play_animation(animationName)
signal play_3d_sound

var buletHitParticleNode = preload("res://assets/scenes/BulletHitParticle.tscn")

onready var player = find_parent("FPSPlayer*")
onready var audioPlayer = get_node("AudioStreamPlayer3D")
onready var cooldownTimer = get_node("Cooldown")
onready var currentAmmo = ammoCapacity

const uiLoadedAmmo = preload("res://assets/resources/loaded_ammo.tres")
const uiReserveAmmo = preload("res://assets/resources/reserve_ammo.tres")


func _ready():
	cooldownTimer.wait_time = 60 / rateOfFire # Convert rounds/minute into time per round.
	cast_to = Vector3(0,0,maxRange)


# Fire 1 bullet, handles all logic and effects.
func primary_fire():
	if(currentAmmo <= 0 or cooldownTimer.is_stopped() == false or isReloading):
		return
	currentAmmo -= 1
	update_ui()
	emit_signal("play_animation", "primary_fire")
	emit_signal("play_3d_sound", fireSound)
	cooldownTimer.start() # Start CycleTimer so this can't shoot before it is done.

	if(is_colliding()):
		emitImpactEffect()
		damageObject()


# Damage the object hit.
func damageObject():
	if(get_collider().is_in_group("Props") and get_collider().get_parent().isNailed):
		return
	if(get_collider().is_in_group("Destructibles")):
		print("wtf")
		get_collider().damage(damage, player)


# Emits a particle effect where the bullet impacted.
func emitImpactEffect():
	var particleInstance = buletHitParticleNode.instance()
	get_collider().add_child(particleInstance)
	particleInstance.global_transform.origin = get_collision_point()
	# Causes the particle to emit perpendicular to the hit surface.
	particleInstance.look_at(get_collision_point() + get_collision_normal(), Vector3.UP) 
	particleInstance.emitting = true


# Starts the reload animation.
func startReload():
	if(isReloading == true or currentAmmo >= ammoCapacity or reserveAmmo <= 0):
		return
	isReloading = true
	emit_signal("play_animation", "reload")
	yield(get_tree().create_timer(1), "timeout")


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
	update_ui()


func is_reserve_full():
	if(reserveAmmo == maxReserveAmmo):
		return true
	else:
		return false


func add_ammo(value):
	if(reserveAmmo + value >= maxReserveAmmo):
		reserveAmmo = maxReserveAmmo
	else:
		reserveAmmo += value
	update_ui()


func update_ui():
	uiLoadedAmmo.Value = currentAmmo
	uiReserveAmmo.Value = reserveAmmo
