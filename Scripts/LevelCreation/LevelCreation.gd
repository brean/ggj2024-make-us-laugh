extends Node3D

var tile_scenes = []

func hex_to_pos(row, col, hexagon_size):
	var vertical_spacing = hexagon_size
	var horizontal_spacing = 1.12 * hexagon_size
	var horizontal_offset = 0.5 * hexagon_size if row % 2 != 0 else 0 

	var x = col * horizontal_spacing + horizontal_offset
	var y = row * vertical_spacing

	return [x, y]


# Called when the node enters the scene tree for the first time.
func _ready():
	tile_scenes.append(preload("res://Scenes/tiles/grassed_tile.tscn"))
	
	for x in range(100):
		for y in range(100):
			var tile = tile_scenes[0]
			var instance = tile.instantiate()
			var pos = hex_to_pos(x, y, 1.8)
			instance.position = Vector3(pos[0], 0, pos[1])
			add_child(instance)
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
