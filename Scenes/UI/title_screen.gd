extends Control

@onready var title_player = $TitlePlayer
@onready var canvas_layer = $"Blink Text/CanvasLayer"

func _ready():
	self.canvas_layer.visible = false

func to_idle():
	self.title_player.play("Idle")
	self.canvas_layer.visible = true


func check_input(dev_idx):
	for key in ["Left", "Right", "Forward", "Backward", "Jump", "Punch"]:
		if MultiplayerInput.is_action_just_pressed(dev_idx, key):
			self.to_start_menu(dev_idx)

func _process(_delta):
	# check joypads
	for dev_idx in MultiplayerInput.handled_devices.size():
		if not MultiplayerInput.handled_devices[dev_idx]:
			continue
		check_input(dev_idx)
	# check keyboard
	check_input(-1)


func to_start_menu(main_dev_idx):
	get_tree().change_scene_to_file("res://Scenes/UI/start_menu.tscn")
