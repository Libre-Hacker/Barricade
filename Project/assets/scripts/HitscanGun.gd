extends Spatial

export(int,1,200) var ammoCapacity # Maximum ammo the gun can hold.
export(int) var reserveAmmo # How much reserve ammo the gun spawns with.
export(int,1,1000) var maxReserveAmmo : int # Maximum ammo held in reserve.
export(float,0.1,1000, 0.1) var damage : float # How much damage each bullet causes.
export(float) var bulletForce = 5 # Amount of physics force the bullet has.
export(float,0,999) var maxRange # The max range of the hitscan ray.
export(float,0,10) var cycleTime # How long it takes the weapon to be ready to fire after shooting. Should be the same time as the "shoot" animation.
export(float) var recoilGain # Recoil gained per shot.
export(float) var recoilRecovery # Recoil recovery per second.
export(float,0,10) var minRecoilValue # The lowest the recoil value can go, 0 is pinpoint accuracy, anything above will have spread, usefull for things like shotguns.
export(Vector2) var maxRecoilSpread # The max x,y direction of the hitscan raycast. Must be positive values.
export(Vector2) var minRecoilSpread # The min x,y direction of the hitscan raycast, Must be negative values.

var recoilValue = 0
var isReloading = false
var fireRate = 1

signal play_animation(animationName)
signal play_camera_animation
signal update_ammo_display

onready var player = GameManager.playerManager.PLAYER
onready var cycleTimer = get_node("CycleTimer")
onready var currentAmmo = ammoCapacity


func _ready():
	# Connects to the camera animator to play camera shake.
	connect("play_camera_animation", find_parent("Camera").get_node("AnimationPlayer"), "_on_change_animation")
	cycleTimer.wait_time = cycleTime


func _process(delta):
	change_recoil(-recoilRecovery * delta)


# Fire 1 bullet, handles all logic and effects.
func primary_fire():
	if(currentAmmo <= 0 or cycleTimer.is_stopped() == false or isReloading):
		return
	currentAmmo -= 1

	update_ui()
	emit_signal("play_animation", "primary_fire", true, true, fireRate)
	emit_signal("play_camera_animation", "recoil")
	cycleTimer.start(cycleTime / fireRate)

	for ray in get_children():
		if(ray is RayCast == false):
			continue
		randomize()
		var xRecoil = clamp(rand_range(-recoilValue,recoilValue),minRecoilSpread.x,maxRecoilSpread.x)
		var yRecoil = clamp(rand_range(-recoilValue,recoilValue),minRecoilSpread.y,maxRecoilSpread.y)
		var recoil = Vector3(xRecoil,yRecoil,0)
		ray.shoot(recoil, damage, bulletForce)
	change_recoil(recoilGain)


# Adds to the recoil value.
func change_recoil(value : float):
	var a = max(abs(minRecoilSpread.x),abs(minRecoilSpread.y))
	var b = max(maxRecoilSpread.x,maxRecoilSpread.y)
	recoilValue += value
	recoilValue = clamp(recoilValue, minRecoilValue, max(a,b))


# Starts the reload animation.
func startReload():
	if(isReloading == true or currentAmmo >= ammoCapacity or reserveAmmo <= 0):
		return
	isReloading = true
	emit_signal("play_animation", "reload")


# Called by the animator after the reload has been completed.
func endReload():
	isReloading = false
	var ammoToReload = ammoCapacity - currentAmmo
	if(reserveAmmo < ammoToReload):
		ammoToReload = reserveAmmo
	
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
	emit_signal("update_ammo_display", currentAmmo, reserveAmmo)



func _on_change_animation(animationName):
	pass # Replace with function body.
