extends Control

var max_points = 10

var focused_button
@onready var play_button = $MarginContainer/VBoxContainer/HBoxContainer/Play
@onready var point_button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button
@onready var quit_button = $MarginContainer/VBoxContainer/Quit

@onready var txt_status = [
	$MarginContainer/HBoxContainer/MarginContainer/connect_status,
	$MarginContainer/HBoxContainer/MarginContainer2/connect_status,
	$MarginContainer/HBoxContainer/MarginContainer3/connect_status,
	$MarginContainer/HBoxContainer/MarginContainer4/connect_status
]

@onready var characters = [
	$Rogue_Hooded,
	$Mage,
	$Knight,
	$Barbarian
]

func _ready():
	focused_button = play_button
	focused_button.grab_focus()

	for idx in range(4):
		update_player(idx)

func check_all_player():
	for idx in range(4):
		var dev_idx = GameManager.player_devices[idx]
		if dev_idx <= -2:
			play_button.disabled = true
			return
	play_button.disabled = false

func update_player(idx):
	var dev_idx = GameManager.player_devices[idx]
	if dev_idx <= -2:
		txt_status[idx].text = "Pending..."
		characters[idx].set_visible(false)
		play_button.disabled = true
		return

	characters[idx].set_visible(true)
	characters[idx].animation_player.play("Cheer")
	if dev_idx == -1:
		txt_status[idx].text = "Keyboard"
	else:
		txt_status[idx].text = "Controller " + str(dev_idx+1)
	
	check_all_player()
		
func check_new_input(dev_idx, spot):
	for key in ["Jump", "Punch"]:
		if MultiplayerInput.is_action_just_pressed(dev_idx, key):
			# add new player to next spot
			GameManager.player_devices[spot] = dev_idx
			update_player(spot)
			

func find_next_spot():
	for idx in GameManager.player_devices.size():
		if GameManager.player_devices[idx] == -2:
			return idx
	return -1

func check_new_player():
	var spot = find_next_spot()
	if spot == -1:
		# we already have 4 player!
		return
	for dev_idx in MultiplayerInput.handled_devices.size():
		if not MultiplayerInput.handled_devices[dev_idx]:
			continue
		if dev_idx in GameManager.player_devices:
			continue
		check_new_input(dev_idx, spot)
	# check keyboard
	if -1 not in GameManager.player_devices:
		check_new_input(-1, spot)

func update_animations():
	for idx in range(4):
		var dev_idx = GameManager.player_devices[idx]
		if dev_idx <= -2:
			return
		var player = characters[idx].animation_player
		if MultiplayerInput.is_action_pressed(dev_idx, "Punch"):
			player.play("Cheer")
		elif player.get_current_animation() != "Cheer":
			player.play("Idle")	

func _process(_delta):
	var button_states = [
		["Left", play_button],
		["Right", point_button],
		["Forward", play_button],
		["Backward", quit_button]
	]
	# let the main controller handle the UI
	var main_idx = GameManager.main_device_idx
	for _state in button_states:
		if MultiplayerInput.is_action_just_pressed(main_idx, _state[0]):
			focused_button = _state[1]
			focused_button.grab_focus()

	if MultiplayerInput.is_action_just_pressed(main_idx, "Jump"):
		var actions = {
			play_button: _on_play_pressed,
			point_button: _on_points_pressed,
			quit_button: _on_quit_pressed
		}
		actions[focused_button].call()
	
	# check for new player
	check_new_player()

	update_animations()

func _on_play_pressed():
	if play_button.disabled:
		return
	GameManager.max_points = max_points
	GameManager.emit_signal("start_game")
	get_tree().change_scene_to_file("res://battle_scene.tscn")


func _on_points_pressed():
	if(max_points < 50):
		max_points += 10
	else:
		max_points = 10
	get_node("MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Button").text = str(max_points)

func _on_quit_pressed():
	get_tree().quit()
