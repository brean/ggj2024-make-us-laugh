extends Control

var max_points = 10

var joined = [false,false,false,false] 
var focused_button
var play_button
var point_button
var quit_button

func _ready():
	play_button = $MarginContainer/VBoxContainer/HBoxContainer/Play
	point_button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button
	quit_button = $MarginContainer/VBoxContainer/Quit
	focused_button = play_button
	focused_button.grab_focus()
	$Rogue_Hooded.set_visible(false)
	$Mage.set_visible(false)
	$Knight.set_visible(false)
	$Barbarian.set_visible(false)


func _on_play_pressed():
	if(Input.get_connected_joypads().size() == 4):
		GameManager.max_points = max_points
		GameManager.emit_signal("start_game")
		get_tree().change_scene_to_file("res://battle_scene.tscn")


func _on_button_pressed():
	if(max_points < 50):
		max_points += 10
	else:
		max_points = 10
	get_node("MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button").text = str(max_points)

func _on_quit_pressed():
	get_tree().quit()
