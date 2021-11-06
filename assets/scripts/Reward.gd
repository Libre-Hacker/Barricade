extends Spatial

# Manages a 2D array of players that have dealth damage to this entity, and pays
# them out their fair portion of money based on the percentage of damage they dealt.

export (int, 0, 1000) var worth = 100 # How much money rewarded for kill.

# 2D array values can be accessed like so: array[0] = first value. array[1] = second value.
# To get the index of that value would look like so: array[0][index] = first value at index.
var contributors = [[],[]] # A 2D array of contributors to the kill.

# Adds, and updates players and how much damage they have dealt to this object.
# Damage is a percent.
func add_contribution(attacker, damage):
	if(attacker == null): # Check for null as some damage sources are not players.
		return
	var i = contributors[0].find(attacker)
	# Adds a new player to the array.
	if(i == -1):
		contributors[0].append(attacker)
		contributors[1].append(damage)
	# Updates the damage dealt by the player.
	else:
		contributors[1][i] = contributors[1][i] + damage

# Pays out the reward to all players in the array.
func distribute_reward():
	for i in contributors[0].size():
		# Convert the percent of damage dealt into an int.
		var reward = contributors[1][i] * worth 
		contributors[0][i].get_node("Wallet").add_money(reward)

func _on_destroyed():
	distribute_reward()

func _on_health_changed(attacker, damage):
	add_contribution(attacker, damage)
