extends Node

var instance = null

func _ready():
	GameManager.points_updated.connect(update_score_label)
		
func update_score_label(player_id, points):
	var label = get_node("Control/MarginContainer/VBoxContainer/HBoxContainer/Score_p" + str(player_id + 2))
	#print(label)
	label.text = str(points)
	
