extends Node3D

var tile_scenes = []

func hex_to_pos(row, col):
	var vertical_spacing = 1.65
	var horizontal_spacing = 2.0
	var horizontal_offset = 0.5 * vertical_spacing if row % 2 != 0 else 0 

	var x = col * horizontal_spacing + horizontal_offset
	var y = row * vertical_spacing

	return [x, y]


# Called when the node enters the scene tree for the first time.
func _ready():
	tile_scenes.append(preload("res://Scenes/tiles/grassed_tile_max.tscn"))
	tile_scenes.append(preload("res://Scenes/tiles/grassed_tile_mid.tscn"))
	tile_scenes.append(preload("res://Scenes/tiles/grassed_tile_min.tscn"))
	tile_scenes.append(preload("res://Scenes/tiles/sand_tile.tscn"))
	
	for x in range(-100, 100):
		for y in range(-100, 100):
			var pos = hex_to_pos(x, y)
			var dist = sqrt(pos[0]**2 + pos[1]**2)
			var tile = tile_scenes[0]
			if dist > 30:
				continue
			elif dist > 28:
				tile = tile_scenes[3]
			elif dist > 25:
				tile = tile_scenes[2]
			elif dist > 20:
				tile = tile_scenes[1]

			
			var instance = tile.instantiate()
			instance.position = Vector3(pos[0], 0, pos[1])
			add_child(instance)
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
