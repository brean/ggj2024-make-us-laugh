extends Node3D

var tile_scenes = []
var tiles = []
var falling_tiles = []
var last_tile_reset = Time.get_ticks_msec()

# let the blocks fall with a speed multiplied by update delta
var falling_speed = 8

# seconds the tiles wiggle before they fall
var wiggle_sec = 1
# reset tiles after x seconds
var reset_tiles_sec = 4

func hex_to_pos(row, col):
	# calculate x and y position in meter based on position in the grid
	var size = 2.31 / 2.0  # dimensions measured in Blender
	var vertical_spacing = 1.65
	var horizontal_spacing = 2.0
	var horizontal_offset = 0.5 * vertical_spacing if row % 2 != 0 else 0 

	var x = col * horizontal_spacing + horizontal_offset
	var y = row * vertical_spacing

	return [x, y]


func preload_tiles():
	tile_scenes.append(preload("res://Scenes/tiles/grassed_tile_max.tscn"))
	tile_scenes.append(preload("res://Scenes/tiles/grassed_tile_mid.tscn"))
	tile_scenes.append(preload("res://Scenes/tiles/grassed_tile_min.tscn"))
	tile_scenes.append(preload("res://Scenes/tiles/sand_tile.tscn"))


func tile_creation():
	var LevelTile = load("res://Scripts/Level/LevelTile.gd")
	var MAX_RADIUS = 18
	for x in range(-MAX_RADIUS, MAX_RADIUS):
		for y in range(-MAX_RADIUS, MAX_RADIUS):
			var pos = hex_to_pos(x, y)
			var dist = sqrt(pos[0]**2 + pos[1]**2)
			var tile_scene = tile_scenes[0]
			if dist > MAX_RADIUS:
				continue
			elif dist > MAX_RADIUS-2:
				tile_scene = tile_scenes[3]
			elif dist > MAX_RADIUS-4:
				tile_scene = tile_scenes[2]
			elif dist > MAX_RADIUS-7:
				tile_scene = tile_scenes[1]

			
			var tile_inst = tile_scene.instantiate()
			tile_inst.position = Vector3(pos[0], 0, pos[1])
			add_child(tile_inst)

			var tile = LevelTile.new(pos[0], pos[1], tile_inst)
			tiles.append(tile)


func reset_tiles():
	for tile in tiles:
		tile.reset_position()
	last_tile_reset = Time.get_ticks_msec()


func set_tiles_as_falling(num_tiles=16):
	falling_tiles = []
	for i in range(num_tiles):
		var tile = tiles[(randi() % tiles.size()) - 1]
		falling_tiles.append(tile)

func _ready():
	preload_tiles()
	tile_creation()
	reset_tiles()
	set_tiles_as_falling()

func let_tiles_fall(delta):
	for tile in falling_tiles:
		tile.fall(falling_speed * delta)

func wiggle(delta):
	for tile in falling_tiles:
		tile.wiggle()

func _process(delta):
	var cur_time = Time.get_ticks_msec()
	if cur_time - last_tile_reset > wiggle_sec * 1000:
		# wiggle time is up, lets fall!
		let_tiles_fall(delta)
	else:
		wiggle(delta)
	
	if cur_time - last_tile_reset > reset_tiles_sec * 1000:
		reset_tiles()
		set_tiles_as_falling()
