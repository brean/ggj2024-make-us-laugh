extends Label

@onready var animation_player = $AnimationPlayer

func play_bounce():
	animation_player.play("bounce")
