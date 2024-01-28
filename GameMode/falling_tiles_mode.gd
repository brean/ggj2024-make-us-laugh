extends GameMode

@export var survival_reward: int = 1
@export var survival_reward_single: int = 3
@export var punch_boost: float = 3

var survivors = []
var level

enum TileFallingMode {
	PLAYER_TOUCH 	= 0,
	RANDOMLY 	= 1,
}

func start():
	level = get_node('../../Level')
	level.set_falling_mode(TileFallingMode.PLAYER_TOUCH)
	survivors = Array(GameManager.players.keys())
	for player in GameManager.players.values():
		player.player_did_fall.connect(on_player_did_fall)
	
	GameManager.flags["prevent_player_reset"] = true
	
func on_player_did_fall(player_id: int):
	survivors.erase(player_id)
	if survivors.size() == 1:
		on_timeout()

func on_timeout():
	level.set_falling_mode(TileFallingMode.RANDOMLY)
	GameManager.flags["prevent_player_reset"] = false
	
	for player_id in survivors:
		GameManager.give_points(player_id, survival_reward_single if survivors.size() == 1 else survival_reward)
	
	for player in GameManager.players.values():
		player.reset_modifiers()
	super.on_timeout()
