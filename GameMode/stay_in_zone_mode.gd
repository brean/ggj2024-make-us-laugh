extends GameMode


@export var amount_of_points := 5
@export var spawn_range := 20.0
@export var punch_boost: float = 2

var player_list = []

@onready var zone = $Zone


func _ready():
	self.zone.visible = false
	super._ready()

func start():
	self.player_list = []

	self.zone.set_deferred("monitoring", true)
	self.zone.set_deferred("monitorable", true)
	self.zone.set_deferred("global_position", 
			Vector3(randf_range(-self.spawn_range, spawn_range), 
					0.5, 
					randf_range(-self.spawn_range, spawn_range)))
	self.zone.visible = true

	for player in GameManager.players.values():
		player.knockback_mod = punch_boost

func on_timeout():
	self.zone.set_deferred("monitoring", false)
	self.zone.set_deferred("monitorable", false)
	self.zone.visible = false

	for player in self.player_list:
		GameManager.give_points(player.player_id, self.amount_of_points)

	for player in GameManager.players.values():
		player.reset_modifiers()

	super.on_timeout()


func _on_zone_body_entered(body):
	self.player_list.append(body)


func _on_zone_body_exited(body):
	self.player_list.erase(body)
