extends "res://Events/event.gd"

func activate_event():
	EventManager.emit_signal("rotate_cam", true)
	

func deactivate_event():
	EventManager.emit_signal("rotate_cam", false)
