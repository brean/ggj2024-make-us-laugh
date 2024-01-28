@tool
extends Node3D

enum TileFallingMode {
	PLAYER_TOUCH 	= 0,
	RANDOMLY 	= 1,
}

var tile_falling_mode = TileFallingMode.RANDOMLY
var grass_tile = preload("res://Scenes/tiles/grassed_tile.tscn")
var sand_tile = preload("res://Scenes/tiles/sand_tile.tscn")
var tiles = []
var falling_tiles = []
var last_tile_reset = Time.get_ticks_msec()
var wiggle_time = 1.0

# let the blocks fall with a speed multiplied by update delta
@export var num_falling_tiles = 20
@export var max_grass = 256

# seconds the tiles wiggle before they fall
@export var wiggle_random_sec = 1
@export var wiggle_player_sec = 1.5
# reset tiles after x seconds
@export var reset_tiles_sec = 4

func hex_to_pos(row, col):
	# calculate x and y position in meter based on position in the grid
	var vertical_spacing = 1.65
	var horizontal_spacing = 2.0
	var horizontal_offset = 0.5 * vertical_spacing if row % 2 != 0 else 0.0

	var x = col * horizontal_spacing + horizontal_offset
	var y = row * vertical_spacing

	return [x, y]


func tile_creation():
	var MAX_RADIUS = 15
	for x in range(-MAX_RADIUS, MAX_RADIUS):
		for y in range(-MAX_RADIUS, MAX_RADIUS):
			var pos = hex_to_pos(x, y)
			var dist = sqrt(pos[0]**2 + pos[1]**2)
			var tile_scene = grass_tile
			var grass_instances = max_grass
			if dist > MAX_RADIUS:
				continue
			elif dist > MAX_RADIUS-2:
				tile_scene = sand_tile
				grass_instances = 0
			elif dist > MAX_RADIUS-4:
				grass_instances = max(max_grass/2., 1)
			elif dist > MAX_RADIUS-7:
				grass_instances = max(max_grass/4., 1)

			var tile = tile_scene.instantiate()
			if grass_instances > 0:
				tile.get_node('Grass').instance_count = grass_instances
			tile.position = Vector3(pos[0], 0, pos[1])
			tile.start_x = pos[0]
			tile.start_z = pos[1]
			add_child(tile)

			tiles.append(tile)


func reset_tiles():
	for tile in tiles:
		tile.reset()
	last_tile_reset = Time.get_ticks_msec()


func set_tiles_as_falling(num_tiles):
	falling_tiles = []
	for i in range(num_tiles):
		var tile = tiles[(randi() % tiles.size()) - 1]
		falling_tiles.append(tile)
		tile.falling = true

func _ready():
	tile_creation()
	reset_tiles()
	if not Engine.is_editor_hint():
		set_tiles_as_falling(num_falling_tiles)

func update_tiles_falling_randomly(delta):
	var cur_time = Time.get_ticks_msec()
	if cur_time - last_tile_reset > reset_tiles_sec * 1000:
		reset_tiles()
		set_tiles_as_falling(num_falling_tiles)

func set_falling_mode(mode: int):
	tile_falling_mode = mode
	if mode == TileFallingMode.RANDOMLY:
		wiggle_time = 1.0
	else:
		wiggle_time = 2.0
	reset_tiles()

func _process(delta):
	if Engine.is_editor_hint():
		return
	if tile_falling_mode == TileFallingMode.RANDOMLY:
		update_tiles_falling_randomly(delta)

