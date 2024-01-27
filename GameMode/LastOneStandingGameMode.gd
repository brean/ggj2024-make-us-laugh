extends GameMode

@export var survival_reward: int = 1
@export var survival_reward_single: int = 3
@export var punch_boost: float = 3

var survivors = []

func start():
	survivors = Array(GameManager.players.keys())
	for player in GameManager.players.values():
		player.knockback_mod = punch_boost
		player.player_did_fall.connect(on_player_did_fall)
	
	GameManager.flags["prevent_player_reset"] = true
	
func on_player_did_fall(player_id: int):
	survivors.erase(player_id)
	if survivors.size() == 1:
		on_timeout()

func on_timeout():
	GameManager.flags["prevent_player_reset"] = false
	
	for player_id in survivors:
		GameManager.give_points(player_id, survival_reward_single if survivors.size() == 1 else survival_reward)
	
	for player in GameManager.players.values():
		player.reset_modifiers()
	super.on_timeout()
