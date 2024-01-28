extends Node

var max = GameManager.max_points

var p = GameManager.points_per_player
var p_cur [0, 0, 0, 0]
var fin_trigger = [false,false,false,false] 
var fin : int = 0
var anims = ["Death_B", "Use_Item", "Jump_Full_Short","Cheer"]
@onready var chars = [
		$"../Node3D/m_p1/Rogue_Hooded",
		$"../Node3D/m_p2/Mage",
		$"../Node3D/m_p3/Knight",
		$"../Node3D/m_p4/Barbarian"]
@onready var labels = [
	$"../MarginContainer/HBoxContainer/Label",
	$"../MarginContainer/HBoxContainer/Label2",
	$"../MarginContainer/HBoxContainer/Label3",
	$"../MarginContainer/HBoxContainer/Label4"]
@onready var poles = [
	$"../Node3D/m_p1",
	$"../Node3D/m_p2",
	$"../Node3D/m_p3",
	$"../Node3D/m_p4"
]
@onready var timer : Timer = $Timer

var top = []
var winner

var played = [false, false, false, false]

var counter : int = 0

var elapsed_time : float = 0


func _ready():
	top.resize(4)
	timer.start(3)
	timer.wait_time = 0.1

func _on_timer_timeout():
	counter += 1
	
	if counter >= max:
		get_node("Timer").stop()

func _process(delta):
	_increase()
	if(counter > 0):
		elapsed_time += delta
		for i in range(4):
			poles[i].position.y = lerp(-2.4, -2.4+(3.3/max)*p[i], clamp(elapsed_time, 0, (float(p[i]+1)/10))/(float(p[i]+1)/10))		
	
	if(counter >= max):
		$"../MarginContainer/Button".set_visible(true)
		$"../MarginContainer/Button".grab_focus()
		if MultiplayerInput.is_action_just_pressed(
				GameManager.main_device_idx, "Jump"):
			_on_button_pressed()
	
func _increase():	
	for i in range(4):
		if(p_cur[i] < p[i]): 
			p_cur[i] = counter
			labels[i].text = str(p_cur[i])
			chars[i].animation_player.play("Idle")
		elif(top[i] == null):
			if(!fin_trigger[i]): 
				top[i] = chars[i]
				fin += 1
				fin_trigger[i] = true;
				if(fin == 4): 
					fin = -1
		if(top[0] == chars[i]):
			if(!played[0]):
				chars[i].animation_player.play(anims[0])
				played[0] = true;
			if(chars[i].animation_player.get_current_animation() != anims[0]):
				anims[0] = "Death_B_Pose"
		if(top[1] == chars[i]):
			if(!played[1]):
				chars[i].animation_player.play(anims[1])
				played[1] = true;
			if(chars[i].animation_player.get_current_animation() != anims[1]):
				anims[1] = "Idle"
			chars[i].animation_player.play(anims[1])
		if(top[2] == chars[i]):
			if(!played[2]):
				chars[i].animation_player.play(anims[2])
				played[2] = true;
			if(chars[i].animation_player.get_current_animation() != anims[2]):
				anims[2] = "Idle"
			chars[i].animation_player.play(anims[2])
		if(top[3] == chars[i]):
			chars[i].animation_player.play(anims[3])	


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/start_menu.tscn")

