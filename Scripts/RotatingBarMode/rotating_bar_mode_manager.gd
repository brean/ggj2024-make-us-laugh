extends Node

# map generation variables
var MAP_RADIUS = 10
var Y_POSITION = 1
var tiles_parent: Node = null
var tiles = {}

func hex_to_pos(grid_x: int, grid_y: int):
	# calculate x and y position in meters based on position in the grid; mostly
	# stolen from andreas
	var vertical_spacing = 1.65
	var horizontal_spacing = 2.0
	var horizontal_offset = 0.5 * vertical_spacing if grid_y % 2 != 0 else 0.0

	var world_x = grid_x * horizontal_spacing + horizontal_offset
	var world_z = grid_y * vertical_spacing

	return Vector3(world_x, Y_POSITION, world_z)

func make_tile(tile_type: String, position: Vector3):
	var tile_instance = tiles[tile_type].instantiate()
	tile_instance.transform.origin = position
	tiles_parent.add_child(tile_instance)

func generate_map():
	for grid_x in range(-MAP_RADIUS, MAP_RADIUS):
		for grid_y in range(-MAP_RADIUS, MAP_RADIUS):
			var tile_position_world = hex_to_pos(grid_x, grid_y)
			var dist = sqrt(tile_position_world.x**2 + tile_position_world.z**2)
			if dist > MAP_RADIUS - 1:
				continue
			if dist > MAP_RADIUS - 2:
				make_tile("sand", tile_position_world)
				continue
			
			make_tile("base", tile_position_world)

# Called when the node enters the scene tree for the first time.
func _ready():
	tiles_parent = get_node("TilesParent")
	tiles["base"] = preload("res://Assets/BaseTiles/tile_base.glb")
	tiles["sand"] = preload("res://Assets/BaseTiles/tile_base_sand.glb")

	generate_map()
