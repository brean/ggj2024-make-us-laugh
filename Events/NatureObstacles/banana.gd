extends Area3D

@export var strength: float = 40000

@onready var ray_cast_3d: RayCast3D = $RayCast3D

var velocity = 0

func _on_body_entered(body):
	var direction = Vector3(randf_range(-1, 1), 0.1, randf_range(-1, 1))
	body.apply_central_force(direction.normalized() * strength)
	$AnimationPlayer.play("shrink")

func _physics_process(delta):
	
	if position.y < GameManager.ResetHeight:
		$AnimationPlayer.play("shrink")
	
	if not ray_cast_3d.is_colliding():
		velocity += 9 * delta
	else:
		velocity = 0
	
	position.y -= velocity * delta
