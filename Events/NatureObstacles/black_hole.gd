extends Node3D

const Force := 425.0

var player_list := []

func _ready():
	EventManager.connect("activate_black_hole", self.activate_hole)
	self.visible = false
	self.set_physics_process(false)
	


func activate_hole(set_on):
	self.set_physics_process(set_on)
	self.visible = set_on


func _physics_process(delta):
	for player in self.player_list:
		var dir = player.global_position.direction_to(self.global_position)
		player.apply_central_force(dir * self.Force)


func _on_area_3d_body_entered(body):
	self.player_list.append(body)


func _on_area_3d_body_exited(body):
	self.player_list.erase(body)
