extends Node

@export var announcement_duration: float = 3

func _ready():
	GameManager.points_updated.connect(update_score_label)
	GameManager.game_mode_updated.connect(on_game_mode_updated)
	GameManager.game_mode_exited.connect(clear_announcement_label)
	
func update_score_label(player_id, points):
	if player_id < 0:
		player_id = 0
	var label = get_node("Control/MarginContainer/VBoxContainer/HBoxContainer/Score_p" + str(player_id + 1))
	label.play_bounce()
	label.text = str(points)

func on_game_mode_updated(game_mode: GameMode):
	update_announcement_label(game_mode.display_name)

func update_announcement_label(text):
	var label = $GameAnnouncementTextAnchor/Label
	var anim_player = $GameAnnouncementTextAnchor/AnimationPlayer
	label.text = text
	anim_player.play("bounce")

func clear_announcement_label():
	var anim_player = $GameAnnouncementTextAnchor/AnimationPlayer
	anim_player.play("disappear")
