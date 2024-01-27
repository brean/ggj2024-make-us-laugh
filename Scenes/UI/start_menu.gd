extends Control

var max_points = 10

var joined = [false,false,false,false]

func _ready():
	$MarginContainer/VBoxContainer/HBoxContainer/Play.grab_focus()
	$Rogue_Hooded.set_visible(false)
	$Mage.set_visible(false)
	$Knight.set_visible(false)
	$Barbarian.set_visible(false)
	
func _process(delta):
	print(Input.get_connected_joypads());
	if(MultiplayerInput.handled_devices[0] && !joined[0]):
		joined[0] = true;
		$Rogue_Hooded.set_visible(true)
		$Rogue_Hooded.animation_player.play("Cheer")
		$MarginContainer/HBoxContainer/MarginContainer/connect_status.text = "Connected"
	elif(!MultiplayerInput.handled_devices[0]):
		$MarginContainer/HBoxContainer/MarginContainer/connect_status.text = "Pending..."
		
	if(MultiplayerInput.handled_devices[1] && !joined[1]):
		joined[1] = true;
		$Mage.set_visible(true)
		$Mage.animation_player.play("Cheer")
		$MarginContainer/HBoxContainer/MarginContainer2/connect_status.text = "Connected"
	elif(!MultiplayerInput.handled_devices[1]):
		$MarginContainer/HBoxContainer/MarginContainer2/connect_status.text = "Pending..."
		
	if(MultiplayerInput.handled_devices[2] && !joined[2]):
		joined[2] = true;
		$Knight.set_visible(true)
		$Knight.animation_player.play("Cheer")
		$MarginContainer/HBoxContainer/MarginContainer3/connect_status.text = "Connected"
	elif(!MultiplayerInput.handled_devices[2]):
		$MarginContainer/HBoxContainer/MarginContainer3/connect_status.text = "Pending..."
		
	if(MultiplayerInput.handled_devices[3] && !joined[3]):
		joined[3] = true;
		$Barbarian.set_visible(true)
		$Barbarian.animation_player.play("Cheer")
		$MarginContainer/HBoxContainer/MarginContainer4/connect_status.text = "Connected"
	elif(!MultiplayerInput.handled_devices[3]):
		$MarginContainer/HBoxContainer/MarginContainer4/connect_status.text = "Pending..."
	
	if(MultiplayerInput.handled_devices[0] && MultiplayerInput.is_action_pressed(0, "Punch")):
		$Rogue_Hooded.animation_player.play("Cheer")
	elif($Rogue_Hooded.animation_player.get_current_animation() != "Cheer"):
		$Rogue_Hooded.animation_player.play("Idle")	
		
	if(MultiplayerInput.handled_devices[1] && MultiplayerInput.is_action_pressed(1, "Punch")):
		$Mage.animation_player.play("Cheer")
	elif($Mage.animation_player.get_current_animation() != "Cheer"):
		$Mage.animation_player.play("Idle")	
		
	if(MultiplayerInput.handled_devices[2] && MultiplayerInput.is_action_pressed(2, "Punch")):
		$Knight.animation_player.play("Cheer")
	elif($Knight.animation_player.get_current_animation() != "Cheer"):
		$Knight.animation_player.play("Idle")	
		
	if(MultiplayerInput.handled_devices[3] && MultiplayerInput.is_action_pressed(3, "Punch")):
		$Barbarian.animation_player.play("Cheer")
	elif($Barbarian.animation_player.get_current_animation() != "Cheer"):
		$Barbarian.animation_player.play("Idle")	

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

