extends Node3D

const Force_in := 500.0
const Force_up := 700.0

var player_list := []

func _ready():
	EventManager.connect("activate_tornado", self.activate_hole)
	self.visible = false
	self.set_physics_process(false)


func activate_hole(set_on):
	self.set_physics_process(set_on)
	self.visible = set_on


func _physics_process(delta):
	for player in self.player_list:
		var dir = self.Force_in * player.global_position.direction_to(self.global_position)
		dir.y = self.Force_up
		player.apply_central_force(dir)


func _on_area_3d_body_entered(body):
	self.player_list.append(body)


func _on_area_3d_body_exited(body):
	self.player_list.erase(body)
