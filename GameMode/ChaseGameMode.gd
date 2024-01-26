extends GameMode

const POINTS_REWARD: int = 1
const POINTS_PENALTY: int = 1

var chasing_player: RigidBody3D
var chased_players: Array[RigidBody3D] = []

func _ready():
	super._ready()
	chasing_player = GameManager.players.pick_random()
	chased_players = Array(GameManager.players)
	chased_players.erase(chasing_player)
	
func on_chased_player_touched():
	pass
