extends Node

var instance = null
var player_scores = [0, 0, 0, 0]

func _ready():
	if instance == null:
		instance = self
	else:
		queue_free()
		
func _input(event):
	if(Input.is_key_pressed(KEY_1)):
		add_score(0, 1)
	if(Input.is_key_pressed(KEY_2)):
		add_score(1, 1)
	if(Input.is_key_pressed(KEY_3)):
		add_score(2, 1)
	if(Input.is_key_pressed(KEY_4)):
		add_score(3, 1)
	
func add_score(player_id, points):
	if player_id >= 0 and player_id < player_scores.size():
		player_scores[player_id] += points
		update_score_label(player_id)
		
func update_score_label(player_id):
	var label = get_node("Control/MarginContainer/VBoxContainer/HBoxContainer/Score_p" + str(player_id + 1))
	#print(label)
	label.text = str(player_scores[player_id])
	
