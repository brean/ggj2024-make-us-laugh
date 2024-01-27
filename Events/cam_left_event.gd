extends "res://Events/event.gd"


func activate_event():
	EventManager.emit_signal("cam_to_the_side", true)
	

func deactivate_event():
	EventManager.emit_signal("cam_to_the_side", false)
