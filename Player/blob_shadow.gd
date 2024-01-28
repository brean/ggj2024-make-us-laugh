extends Node3D

const ColorList = [Color("660efe"), Color("fc6a3a"), 
					Color("3afccd"), Color("fff40f")]

@onready var ray_cast_3d = $RayCast3D
@onready var decal = $Decal

func _physics_process(delta):
	if self.ray_cast_3d.is_colliding():
		self.decal.visible = true
		var coll_y = ray_cast_3d.get_collision_point().y
		self.decal.global_position.y = coll_y
	else:
		self.decal.visible = false


func set_color(player_id):
	self.decal.modulate = self.ColorList[player_id]
