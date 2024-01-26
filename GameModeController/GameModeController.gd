extends Node3D

signal game_mode_changed(game_mode: GameMode)

@export var game_modes: Array[PackedScene] # array from which game modes are selected

func _ready():
	on_game_mode_finished()

func set_game_mode(game_mode_scene: PackedScene):
	var game_mode: GameMode = game_mode_scene.instantiate()
	game_mode.finished.connect(on_game_mode_finished)
	add_child(game_mode)
	game_mode_changed.emit(game_mode)

func on_game_mode_finished():
	var random_game_mode_scene = game_modes.pick_random()
	set_game_mode(random_game_mode_scene)
