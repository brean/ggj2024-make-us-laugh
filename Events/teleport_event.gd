extends "res://Events/event.gd"

@onready var particle_list = [$TeleportParticles, $TeleportParticles2, 
								$TeleportParticles3, $TeleportParticles4]

func activate_event():
	var position_array = []
	var player_okay = []
	
	for player in GameManager.players.values():
		if player.global_position.y > GameManager.ResetHeight:
			position_array.append(player.global_position)
			player_okay.append(true)
		else:
			player_okay.append(false)
	
	position_array.shuffle()

	var counter = 0
	var idx = 0
	for player in GameManager.players.values():
		if player_okay[idx]:
			self.particle_list[idx].global_position = position_array[counter]
			self.particle_list[idx].emitting = true
			player.global_position = position_array[counter]
			counter += 1
		idx += 1
	

func deactivate_event():
	pass
