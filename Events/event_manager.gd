extends Node3D

const EventList = [ preload("res://Events/canon_event.tscn"), 
					preload("res://Events/gravity_event.tscn"), 
					preload("res://Events/change_controlls.tscn"), 
					preload("res://Events/speed_event.tscn"), 
					preload("res://Events/slow_event.tscn"), 
					preload("res://Events/cam_left_event.tscn"), 
					preload("res://Events/turn_cam_event.tscn"), 
					preload("res://Events/teleport_event.tscn"), 
					preload("res://Events/black_hole_event.tscn")]

var EventNodes := []
var event_idx := []

@export var wait_time_scale = 2.0

@onready var wait_timer = $WaitTimer
@onready var event_timer = $EventTimer
@onready var label = $TextLabel/Label
@onready var animation_player = $AnimationPlayer

signal activate_canons
signal activate_black_hole
signal activate_tornado

signal rotate_cam
signal cam_to_the_side

func _ready():
	GameManager.connect("start_game", self.start_events)
	GameManager.connect("end_game", self.stop_events)
	
	self.label.visible = false
	for event in EventList:
		var new_event = event.instantiate()
		self.add_child(new_event)
		self.EventNodes.append(new_event)


func _on_wait_timer_timeout():
	self.event_idx = []
	self.event_idx.append(-1)#randi_range(0, len(self.EventList)-1))
	if GameManager.current_max >= GameManager.max_points/2.0:
		var additional_event = randi_range(0, len(self.EventList)-1)
		if additional_event == self.event_idx[0]:
			additional_event += 1
		self.event_idx.append(additional_event)
	
	var event_name = ""
	var start_event = true
	for e_idx in self.event_idx:
		if not start_event:
			event_name += "\n + \n"
		self.EventNodes[e_idx].activate_event()
		self.event_timer.start(self.EventNodes[e_idx].event_time)
		
		event_name += self.EventNodes[e_idx].event_name
		start_event = false
	
	self.label.text = event_name 
	self.label.visible = true
	self.animation_player.play("TextAppear")


func _on_event_timer_timeout():
	self.label.visible = false
	self.wait_timer.start(randf_range(3.0, self.wait_time_scale))
	for e_idx in self.event_idx:
		self.EventNodes[e_idx].deactivate_event()


func start_events():
	self.wait_timer.start(self.wait_time_scale)


func stop_events():
	self.wait_timer.stop()
	self.event_timer.stop()
	self.label.visible = false
	for e_idx in self.event_idx:
		self.EventNodes[self.e_idx].deactivate_event()


func to_idle():
	self.animation_player.play("Idle")
