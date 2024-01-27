extends "res://Events/event.gd"


func activate_event():
	var scale = randf_range(0.4, 0.6)
	for player in GameManager.players.values():
		player.gravity_scale = scale
	

func deactivate_event():
	for player in GameManager.players.values():
		player.gravity_scale = 1.0

