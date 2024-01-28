extends AnimationPlayer

var time_elapsed = 0

@onready
var time_max : int = get_meta("time_max")

@onready
var speed_min : float = get_meta("speed_min")

@onready
var speed_max : float = get_meta("speed_max")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time_elapsed >= time_max:
		return
	
	time_elapsed += delta
	var t = time_elapsed / time_max

	# lerp
	self.speed_scale = speed_min * (1 - t) + speed_max * t
	
	

