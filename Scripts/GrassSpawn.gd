extends MultiMeshInstance3D

var multi_mesh = MultiMesh.new()
@export var max_radius = 1.0
@export var instance_count = 256

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	multi_mesh.transform_format = MultiMesh.TRANSFORM_3D
	multi_mesh.mesh = preload("res://Assets/grass/grass.res")
	multi_mesh.instance_count = instance_count
	self.multimesh = multi_mesh

	for i in range(multi_mesh.instance_count):
		var _transform = Transform3D()
		# Randomly position each instance within a given range
		var r = randf_range(0.2, max_radius)

		var theta = randf_range(-3.1415, 3.1415)
		var x = r * cos(theta)
		var z = r * sin(theta)
		_transform.origin = Vector3(x, 0, z)
		_transform.basis = Basis(Vector3(0, 1, 0), randf_range(-3.1415, 3.1415))
		# transform.rotated(Vector3(0, 1, 0), randf_range(-3.1415, 3.1415))

		# Add each transform to the MultiMesh
		multi_mesh.set_instance_transform(i, _transform)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
