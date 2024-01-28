extends GameMode

const Coin = preload("res://GameMode/Collectables/point_coin.tscn")

@export var number_of_coins = 15
@export var spawn_range = 25.0

func start():
	var spawn_n = randi_range(-3, 3) + self.number_of_coins
	for i in range(spawn_n):
		var new_coin = Coin.instantiate()
		self.add_child(new_coin)
		new_coin.global_position = Vector3(
			randf_range(-self.spawn_range, self.spawn_range), 
			randf_range(8.0, 12.0), 
			randf_range(-self.spawn_range, self.spawn_range)
		)


