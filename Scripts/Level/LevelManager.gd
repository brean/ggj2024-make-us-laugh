extends Node3D

var tile_scenes = []
var tiles = []

func hex_to_pos(row, col):
	# calculate x and y position in meter based on position in the grid
	var size = 2.31 / 2.0  # dimensions measured in Blender
	var vertical_spacing = 1.65
	var horizontal_spacing = 2.0
	var horizontal_offset = 0.5 * vertical_spacing if row % 2 != 0 else 0 

	var x = col * horizontal_spacing + horizontal_offset
	var y = row * vertical_spacing

	return [x, y]


func tile_creation():
	tile_scenes.append(preload("res://Scenes/tiles/grassed_tile_max.tscn"))
	tile_scenes.append(preload("res://Scenes/tiles/grassed_tile_mid.tscn"))
	tile_scenes.append(preload("res://Scenes/tiles/grassed_tile_min.tscn"))
	tile_scenes.append(preload("res://Scenes/tiles/sand_tile.tscn"))
	
	var MAX_RADIUS = 18
	for x in range(-MAX_RADIUS, MAX_RADIUS):
		for y in range(-MAX_RADIUS, MAX_RADIUS):
			var pos = hex_to_pos(x, y)
			var dist = sqrt(pos[0]**2 + pos[1]**2)
			var tile = tile_scenes[0]
			if dist > MAX_RADIUS:
				continue
			elif dist > MAX_RADIUS-2:
				tile = tile_scenes[3]
			elif dist > MAX_RADIUS-4:
				tile = tile_scenes[2]
			elif dist > MAX_RADIUS-7:
				tile = tile_scenes[1]

			
			var instance = tile.instantiate()
			instance.position = Vector3(pos[0], 0, pos[1])
			add_child(instance)
			tiles.append(instance)


func reset_tiles():
	for tile in tiles:
		var position = tile.position
		# position.y = randi() % 3
		position.y = 0
		tile.position = position


func _ready():
	tile_creation()
	reset_tiles()
			

func _process(delta):
	pass
