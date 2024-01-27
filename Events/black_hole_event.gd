extends "res://Events/event.gd"

func activate_event():
	EventManager.emit_signal("activate_black_hole", true)
	

func deactivate_event():
	EventManager.emit_signal("activate_black_hole", false)
