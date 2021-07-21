extends Spatial

enum fireModes {semiAuto, fullAuto}

export(fireModes) var selectedFireMode
export(int,1,200) var maxAmmo : int # Maximum ammo the gun can hold.
export(float,1,1024) var rateOfFire : float # The weapons cycle time, in rounds/minute. NOTE: Should match animations.
export(float,0,30) var reloadTime : float # Time in seconds reloading takes. NOTE: Should match animations.
export(float,0.1,1000, 0.1) var damage : float
export var startLoaded : bool = true
