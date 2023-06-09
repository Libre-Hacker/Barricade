extends Spatial

export var rewardAmount = 100 # How much money to reward.

# Pays out the reward to the player.
func _on_give_reward(value = null):
	var reward = value if value != null else rewardAmount
	GameManager.playerManager.PLAYER.get_node('Wallet').add_money(reward)
