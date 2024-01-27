extends "res://Events/event.gd"


func activate_event():
	for player in GameManager.players.values():
		var angle = randf_range(0.0, 2.0*PI)
		player.direction_rot = angle
	

func deactivate_event():
	for player in GameManager.players.values():
		player.direction_rot = 0.0
