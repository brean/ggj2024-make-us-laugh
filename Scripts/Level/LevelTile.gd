class_name LevelTile

var start_x
var start_z
var tile_inst

func _init(x, z, inst):
	start_x = x
	start_z = z
	tile_inst = inst

func reset_position():
	var position = tile_inst.position
	position.x = start_x
	position.y = 0
	position.z = start_z
	tile_inst.position = position

func fall(y):
	var position = tile_inst.position
	position.y -= y
	tile_inst.position = position

func wiggle():
	var position = tile_inst.position
	position.x = start_x + (randi() % 100 - 50) * 0.002
	position.z = start_z + (randi() % 100 - 50) * 0.002
	tile_inst.position = position
