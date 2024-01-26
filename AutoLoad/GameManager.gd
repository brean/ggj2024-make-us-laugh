extends Node

signal points_updated(player_id: int, points: int)

var players: Dictionary = {}
var points_per_player: Dictionary = {}

func give_points(player_id: int, points: int):
	
	if not points_per_player.has(player_id):
		points_per_player[player_id] = 0
	
	points_per_player[player_id] += points
	points_updated.emit(player_id, points_per_player[player_id])
