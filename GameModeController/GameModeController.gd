extends Node3D

@export var delay_between_modes: float = 1
@export var game_modes: Array[PackedScene] # array from which game modes are selected

@onready var delay_timer = $DelayTimer

func _ready():
	on_game_mode_finished()

func on_game_mode_finished():
	GameManager.game_mode_exited.emit()
	self.delay_timer.start(self.delay_between_modes)


func _on_delay_timer_timeout():
	var game_mode_scene = game_modes.pick_random() # choose game mode at random
	var game_mode: GameMode = game_mode_scene.instantiate()
	game_mode.finished.connect(on_game_mode_finished)
	add_child(game_mode)
	GameManager.game_mode_updated.emit(game_mode)
	game_mode.start()
