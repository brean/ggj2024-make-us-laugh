extends GameMode

const ImagesList = [preload("res://GameMode/Images/Burger.png"), 
					preload("res://GameMode/Images/Carrot1.png"),
					preload("res://GameMode/Images/Carrot2.png"), 
					preload("res://GameMode/Images/Pizza1.png"), 
					preload("res://GameMode/Images/Pizza2.png"), 
					preload("res://GameMode/Images/Tomato.png"), 
					preload("res://GameMode/Images/Sheep.png")]

@export var amount_of_points := 4

var mode_is_active = false
var first_time = true

var teams := [[0, 0], [0,0]]
var team_2 := [0, 0]

func start():
	var player_idx_copy = GameManager.players.keys().duplicate()
	player_idx_copy.shuffle()
	
	for i in range(2):
		teams[0][i] = player_idx_copy[i]
		teams[1][i] = player_idx_copy[i+2]
	
	# activate areas
	for player in GameManager.players.values():
		player.touch_area.set_on(true)
		if self.first_time:
			player.touch_area.connect("touched_other_player", self.players_touched)
	
	# set image
	var team_1_image = -1
	for i in range(2):
		var image_idx = randi_range(0, len(self.ImagesList)-1)
		if image_idx == team_1_image:
			image_idx = (image_idx + 1) % len(self.ImagesList)
		for j in range(2):
			GameManager.players[teams[i][j]].game_symbol.visible = true
			GameManager.players[teams[i][j]].game_symbol.texture = \
					self.ImagesList[image_idx]
		team_1_image = image_idx
	
	self.mode_is_active = true
	self.first_time = false


func players_touched(self_id: int, enemy_id: int):
	if self.mode_is_active:
		for i in range(2):
			if self_id in teams[i] and enemy_id in teams[i]:
				GameManager.give_points(self_id, self.amount_of_points)
				GameManager.give_points(enemy_id, self.amount_of_points)
				
				self.on_timeout()


func on_timeout():
	# deaativate areas
	for player in GameManager.players.values():
		player.touch_area.set_on(false)
		player.game_symbol.visible = false

	self.mode_is_active = false
	super.on_timeout()
