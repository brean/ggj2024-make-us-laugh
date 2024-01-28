extends Node

const ResetHeight = -5.0

signal points_updated(player_id: int, points: int)
signal game_mode_updated(game_mode: GameMode)
signal game_mode_exited

signal start_game
signal end_game

var players: Dictionary = {}
var points_per_player: Dictionary = {}

var max_points := 10
var current_max := 0

var flags: Dictionary = {
	# used during some events to prevent players from respawning
	"prevent_player_reset": false
}


func register_player(player_object):
	self.players[player_object.player_id] = player_object
	self.points_per_player[player_object.player_id] = 0


func give_points(player_id: int, points: int):
	
	if not points_per_player.has(player_id):
		points_per_player[player_id] = 0
	
	points_per_player[player_id] = max(0, points_per_player[player_id] + points)
	points_updated.emit(player_id, points_per_player[player_id])
	
	if points_per_player[player_id] >= max_points:
		self.emit_signal("end_game")
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/UI/end_menu.tscn")
	
	current_max = points_per_player.values().max()
