extends Node3D

@export var delay_between_modes: float = 2
@export var game_modes: Array[PackedScene] # array from which game modes are selected

func _ready():
	on_game_mode_finished()

func on_game_mode_finished():
	var game_mode_scene = game_modes.pick_random() # choose game mode at random
	var game_mode: GameMode = game_mode_scene.instantiate()
	game_mode.finished.connect(on_game_mode_finished)
	add_child(game_mode)
	GameManager.game_mode_updated.emit(game_mode)
	
	await get_tree().create_timer(delay_between_modes).timeout
	
	game_mode.start()
