extends Node3D

@onready var animation_player = $AnimationPlayer

func _ready():
	EventManager.connect("rotate_cam", self.rotate_cam)
	EventManager.connect("cam_to_the_side", self.cam_to_the_left)
	

func rotate_cam(on_head):
	if on_head:
		self.animation_player.play("Turn_on_Head")
	else:
		self.animation_player.play_backwards("Turn_on_Head")


func cam_to_the_left(turn_left):
	if turn_left:
		self.animation_player.play("Turn_Left")
	else:
		self.animation_player.play_backwards("Turn_Left")
