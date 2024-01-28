extends Node3D
class_name LevelTile

var falling_speed = 2
@export var start_x = 0
@export var start_z = 0
var max_falling_pos = -10
var last_reset = Time.get_ticks_msec()
var falling = false
var level

enum TileFallingMode {
	PLAYER_TOUCH 	= 0,
	RANDOMLY 	= 1,
}

func reset():
	var _position = self.position
	_position.x = start_x
	_position.y = 0
	_position.z = start_z
	self.position = _position
	falling = false
	last_reset = Time.get_ticks_msec()

func fall(y):
	var _position = self.position
	if _position.y <= max_falling_pos:
		return
	_position.y -= y
	self.position = _position

func wiggle():
	var _position = self.position
	_position.x = start_x + (randi() % 100 - 50) * 0.002
	_position.z = start_z + (randi() % 100 - 50) * 0.002
	self.position = _position

func test_touch_tile():
	if level.tile_falling_mode == TileFallingMode.PLAYER_TOUCH:
		start_falling()

func start_falling():
	reset()
	falling = true

func let_tile_fall(delta):
	fall(falling_speed * delta)

func _ready():
	level = get_node('..')

func _process(delta):
	if Engine.is_editor_hint():
		return
	if not falling:
		return
	var cur_time = Time.get_ticks_msec()
	if cur_time - last_reset > level.wiggle_time * 1000:
		# wiggle time is up, lets fall!
		let_tile_fall(delta)
	else:
		wiggle()
