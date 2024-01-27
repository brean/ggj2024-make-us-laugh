extends "res://Events/event.gd"


func activate_event():
	for player in GameManager.players.values():
		var scale = randf_range(1.5, 2.5)
		player.max_speed *= scale
	

func deactivate_event():
	for player in GameManager.players.values():
		player.max_speed = player.OriginalSpeed
