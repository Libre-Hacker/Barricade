extends Spatial
# Manages a 2D array of players that have contributed to the reward, and pays
# them out their portion of money based on the percentage of value they provided.

export var payoutOnDeath = true # If true, payouts are only distributed upon death.
export var rewardAmount = 100 # How much money rewarded for kill.

# 2D array values can be accessed like so: array[0] = first value. array[1] = second value.
# To get the index of that value would look like so: array[0][index] = first value at index.
var contributors = [[],[]] # A 2D array of contributors to the kill.

# Adds players, and updates how much damage they have dealt to this object.
# Damage is a percent.
func add_contribution(attacker, value):
	# Searches the array for the attacking player.
	var i = contributors[0].find(attacker)

	# Adds a new player to the array.
	if(i == -1):
		contributors[0].append(attacker)
		contributors[1].append(value)
	# Updates the value contributed by the player.
	else:
		contributors[1][i] = contributors[1][i] + value
	print(contributors)

# Pays out the reward to all players in the array.
func distribute_reward(maxValue):
	for i in contributors[0].size():
		# Convert the contribution of each player into a percentage of the total
		# contributions, and payout their percentage of the reward.
		var reward = clamp(rewardAmount * (contributors[1][i] / maxValue), 0, rewardAmount)
		contributors[0][i].get_node("Wallet").add_money(reward)

# Pays out an instant reward to the player, default reward can be overridden.
func give_instant_reward(player, reward = rewardAmount):
	player.get_node("Wallet").add_money(reward)


# Adds reward when health_changed signal is received.
func _on_health_changed(attacker, value):
	if(attacker == null): # Check if attacking source can collect rewards.
		return
	if(payoutOnDeath):
		add_contribution(attacker, value)
	else:
		give_instant_reward(attacker)
