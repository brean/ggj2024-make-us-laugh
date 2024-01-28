extends Control

@onready var title_player = $TitlePlayer
@onready var canvas_layer = $"Blink Text/CanvasLayer"

func _ready():
	self.canvas_layer.visible = false

func to_idle():
	self.title_player.play("Idle")
	self.canvas_layer.visible = true


func _process(delta):
	if MultiplayerInput.is_action_just_pressed(0, "ui_left"):
		self.to_start_menu()
	if MultiplayerInput.is_action_just_pressed(0, "ui_right"):
		self.to_start_menu()
	if MultiplayerInput.is_action_just_pressed(0, "ui_up"):
		self.to_start_menu()
	if MultiplayerInput.is_action_just_pressed(0, "ui_down"):
		self.to_start_menu()
	if MultiplayerInput.is_action_just_pressed(0, "Jump"):
		self.to_start_menu()


func to_start_menu():
	get_tree().change_scene_to_file("res://Scenes/UI/start_menu.tscn")
