extends Control

var max_points = 10

func _process(delta):
	$Barbarian.animation_player.play("Idle")	
	$Mage.animation_player.play("Idle")	
	$Rogue_Hooded.animation_player.play("Idle")	
	$Knight.animation_player.play("Idle")

func _on_play_pressed():
	if(Input.get_connected_joypads().size() > 1):
		get_tree().change_scene_to_file("res://battle_scene.tscn")


func _on_button_pressed():
	if(max_points < 50):
		max_points += 10
	else:
		max_points = 10
	get_node("MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button").text = str(max_points)

func _on_quit_pressed():
	get_tree().quit()


