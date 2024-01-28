extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var follow_group = $"../PlayerPhantomCamera3D".follow_group
	for player in follow_group:
		print(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
