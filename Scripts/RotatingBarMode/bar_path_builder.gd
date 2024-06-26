extends Path3D


func activate_bar(set_on):
	self.set_physics_process(set_on)
	self.visible = set_on


func add_points():
	print("Adding path points")
	var position_min : Vector2 = get_meta("position_min")
	var position_max : Vector2 = get_meta("position_max")
	var position_y : float = get_meta("world_y")

	# bottom edge
	for x in range(position_min.x, position_max.x):
		self.curve.add_point(Vector3(x, position_y, position_min.y))
	
	# right edge
	for y in range(position_min.y, position_max.y):
		self.curve.add_point(Vector3(position_max.x, position_y, y))
	
	# top edge
	for x in range(position_max.x, position_min.x, -1):
		self.curve.add_point(Vector3(x, position_y, position_max.y))
	
	# left edge
	for y in range(position_max.y, position_min.y, -1):
		self.curve.add_point(Vector3(position_min.x, position_y, y))
	
	self.curve_changed.emit()


# Called when the node enters the scene tree for the first time.
func _ready():
	add_points()
	EventManager.connect("activate_bar", self.activate_bar)
	self.visible = false
	self.set_physics_process(false)
