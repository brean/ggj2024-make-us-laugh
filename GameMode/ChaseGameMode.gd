extends GameMode

@export var catch_reward: int = 1
@export var survival_reward: int = 2

var chasing_player_id: int
var chased_player_ids: Array = []
var caught_player_ids: Array = []

func _ready():
	super._ready()
	chasing_player_id = GameManager.players.keys().pick_random()
	chased_player_ids = Array(GameManager.players.keys())
	chased_player_ids.erase(chasing_player_id)
	print("chasing: ", chasing_player_id, " chased: ", chased_player_ids)

func start():
	for player_id in chased_player_ids:
		GameManager.players[player_id].got_hit.connect(on_chased_player_touched)

func on_chased_player_touched(self_id: int, enemy_id: int):
	if not self_id in caught_player_ids and enemy_id == chasing_player_id:
		# player caught
		caught_player_ids.append(self_id)
		GameManager.give_points(chasing_player_id, catch_reward)
	
	var chase_over = true
	for id in chased_player_ids:
		if id not in caught_player_ids:
			chase_over = false
			break
			
	if chase_over: on_timeout()

func on_timeout():
	for player_id in chased_player_ids:
		if player_id not in caught_player_ids:
			GameManager.give_points(player_id, survival_reward)
	super.on_timeout()
