extends Spatial

export var rewardAmount = 100 # How much money to reward.

# Pays out the reward to the player.
func _on_give_reward():
	GameManager.playerManager.PLAYER.get_node('Wallet').add_money(rewardAmount)
