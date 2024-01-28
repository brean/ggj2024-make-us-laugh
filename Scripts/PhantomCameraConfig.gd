extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	for player in GameManager.players.values():
		player.player_did_fall.connect(on_player_did_fall)
		player.player_reset.connect(on_player_reset)


func on_player_did_fall(player_id: int):
	var this_player = GameManager.players[player_id]
	for player in $"../PlayerPhantomCamera3D".follow_group:
		if this_player == get_node(player):
			$"../PlayerPhantomCamera3D".erase_follow_group_node(this_player)
			return

func on_player_reset(player_id: int):
	$"../PlayerPhantomCamera3D".append_follow_group_node(
		GameManager.players[player_id])

