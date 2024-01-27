extends Path3D

func _ready():
	EventManager.connect("activate_bar", self.activate_bar)
	self.visible = false
	self.set_physics_process(false)


func activate_bar(set_on):
	self.set_physics_process(set_on)
	self.visible = set_on
