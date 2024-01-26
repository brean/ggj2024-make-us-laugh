extends GameMode

const POINTS_REWARD: int = 1
const POINTS_PENALTY: int = -1

var chasing_player_id: int
var chased_player_ids: Array = []
var caught_player_ids: Array = []

func _ready():
	super._ready()
	chasing_player_id = GameManager.players.keys().pick_random()
	chased_player_ids = Array(GameManager.players.keys())
	chased_player_ids.erase(chasing_player_id)
	print("chasing: ", chasing_player_id, " chased: ", chased_player_ids)
	for player_id in chased_player_ids:
		GameManager.players[player_id].got_hit.connect(on_chased_player_touched)
	
func on_chased_player_touched(self_id: int, enemy_id: int):
	if not self_id in caught_player_ids and enemy_id == chasing_player_id:
		# player caught
		caught_player_ids.append(self_id)
		GameManager.give_points(self_id, POINTS_PENALTY)
		GameManager.give_points(chasing_player_id, POINTS_REWARD)
