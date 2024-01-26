extends RigidBody3D

const MaterialList = [preload("res://Player/Materials/player_blue.tres"), 
					  preload("res://Player/Materials/player_red.tres"), 
					  preload("res://Player/Materials/player_green.tres"), 
					  preload("res://Player/Materials/player_yellow.tres")]

const OriginalSpeed := 5.5
const OriginalAcc := 14.5
const OriginalJumpImpulse := 250.0
const RotationSpeed := 0.2

@export var player_id := 0

@export var max_speed := self.OriginalSpeed
@export var acceleration := self.OriginalAcc
@export var jump_impulse := self.OriginalJumpImpulse
@export var dummy := true

var direction := Vector2.ZERO
var current_weapon : Weapon
var can_reset := false

@onready var model = $ModelNode
@onready var ground_cast = $GroundCast
@onready var hurtbox = $Hurtbox
@onready var weapon_hand = $ModelNode/WeaponHand


signal got_hit # self id any enemy id that hit this player
signal player_did_fall 

func _ready():
	self.hurtbox.player = self
	self.hurtbox.connect("got_hit", self.hitbox_got_hit)
	self.update_weapon()
	$ModelNode/Model.material_override = self.MaterialList[self.player_id]

func _physics_process(delta):
	# Get input
	if not self.dummy:
		self.direction.x = - MultiplayerInput.get_action_strength(self.player_id, "Left") \
							+ MultiplayerInput.get_action_strength(self.player_id, "Right")
		self.direction.y = - MultiplayerInput.get_action_strength(self.player_id, "Forward") \
							+ MultiplayerInput.get_action_strength(self.player_id, "Backward")

		# Add impuls if not to fast
		var horizontal_velocity = Vector2(self.linear_velocity.x, self.linear_velocity.z)
		if horizontal_velocity.length() < self.max_speed:
			var input_strength = self.direction.length()
			self.direction = min(1.0, input_strength) * self.direction.normalized()
			self.apply_central_impulse(acceleration * Vector3(self.direction.x, 0.0, self.direction.y))
		
		# Jump
		if MultiplayerInput.is_action_just_pressed(self.player_id, "Jump"):
			self.ground_cast.force_raycast_update()
			if self.ground_cast.is_colliding():
				self.apply_central_impulse(jump_impulse * Vector3(0.0, 1.0, 0.0))

		# Attack
		if MultiplayerInput.is_action_pressed(self.player_id, "Punch"):
			self.current_weapon.use_weapon()

		# Reset if stuck (maybe remove later)
		if MultiplayerInput.is_action_just_pressed(self.player_id, "Reset") and self.can_reset:
			self.reset_player()

	# Rotate model
	self.rotate_model()

	if self.global_position.y < -5:
		self.reset_player()
		self.emit_signal("player_did_fall", self.player_id)


func rotate_model():
	var look_direction = Vector2(self.linear_velocity.x, -self.linear_velocity.z)
	if look_direction.length_squared() > 0.01:
		self.model.rotation.y = lerp_angle(self.model.rotation.y, look_direction.angle() + PI/2.0, 
											self.RotationSpeed)


func update_weapon():
	self.current_weapon = self.weapon_hand.get_children()[-1]
	self.current_weapon.update_owner(self.player_id)


func hitbox_got_hit(enemy_id):
	self.emit_signal("got_hit", self.player_id, enemy_id)


func reset_player():
	self.global_position = Vector3(0, 5.0, 0)
	self.linear_velocity = Vector3(0, 0, 0)
