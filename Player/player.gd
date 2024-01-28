extends RigidBody3D
class_name Player

const ModelList = [preload("res://Player/Models/rogue_hooded.tscn"), 
					preload("res://Player/Models/mage.tscn"), 
					preload("res://Player/Models/knight.tscn"), 
					preload("res://Player/Models/barbarian.tscn")]

const OriginalSpeed := 6.5
const OriginalAcc := 15.0
const OriginalJumpImpulse := 250.0
const RotationSpeed := 0.2
const IdleThreshold := 0.01
const OriginalKnockbackModifier := 1

enum PlayerStates {IDLE, MOVE, JUMP, FALL, ATTACK, DUMMY}

@export var player_id := 0

@export var max_speed := self.OriginalSpeed
@export var acceleration := self.OriginalAcc
@export var jump_impulse := self.OriginalJumpImpulse
@export var current_state : PlayerStates = self.PlayerStates.IDLE
@export var knockback_mod : float = 1

var direction := Vector2.ZERO
var old_velocity_xz := Vector2.ZERO
var direction_rot := 0.0

var current_weapon : Weapon

var can_reset := false
var start_state := true

# resetting falling players will be disabled during some events.
# this ensures that a fall-signal only gets send once.
var surpress_player_fall_signal := false

var char_model : CharacterModel

@onready var model = $ModelNode
@onready var ground_cast = $GroundCast
@onready var hurtbox = $Hurtbox
@onready var weapon_hand = $ModelNode/WeaponHand
@onready var game_symbol = $GameSymbol:
	get:
		return game_symbol
@onready var touch_area = $ModelNode/TouchArea

### Particles
@onready var jump_trail_particles = $Particles/JumpTrail
@onready var run_trail = $Particles/RunTrail

### Sound
@onready var falling_in_water_sound = $FallingInWaterSound


signal got_hit # self id any enemy id that hit this player
signal player_did_fall 


func _ready():
	GameManager.register_player(self)
	self.hurtbox.player = self
	self.hurtbox.connect("got_hit", self.hitbox_got_hit)
	self.update_weapon()
	
	self.touch_area.player = self
	
	var new_char_model = self.ModelList[self.player_id].instantiate()
	self.model.add_child(new_char_model)
	self.char_model = new_char_model
	$ModelNode/Model.queue_free()

	self.game_symbol.visible = false
	$BlobShadow.set_color(self.player_id)


func _physics_process(_delta):
	if self.global_position.y < GameManager.ResetHeight:
		if not GameManager.flags["prevent_player_reset"]:
			self.reset_player()
		
		if not surpress_player_fall_signal:
			self.emit_signal("player_did_fall", self.player_id)
			surpress_player_fall_signal = true
			falling_in_water_sound.play()
	else:
		surpress_player_fall_signal = false
	
	
	match self.current_state:
		PlayerStates.IDLE:
			self.idle_state()
		PlayerStates.MOVE:
			self.move_state()
		PlayerStates.JUMP:
			self.jump_state()
		PlayerStates.ATTACK:
			self.attack_state()
		PlayerStates.FALL:
			self.fall_state()
		PlayerStates.DUMMY:
			return # nothing to do here
	
	# Jump
	if MultiplayerInput.is_action_just_pressed(self.player_id, "Jump"):
		self.change_state(PlayerStates.JUMP)

	# Attack
	if MultiplayerInput.is_action_pressed(self.player_id, "Punch"):
		if not self.current_weapon.on_cooldown:
			#var look_direction = Vector2(self.direction.x, -self.direction.y)
			#self.model.rotation.y =  look_direction.angle() + PI/2.0
			self.change_state(PlayerStates.ATTACK)
			self.current_weapon.use_weapon()

	# Reset if stuck (maybe remove later)
	if MultiplayerInput.is_action_just_pressed(self.player_id, "Reset") and self.can_reset:
		self.reset_player()

	# Rotate model
	self.rotate_model()


func rotate_model():
	var look_direction = Vector2(self.linear_velocity.x, -self.linear_velocity.z)
	if look_direction.length_squared() > self.IdleThreshold:
		self.model.rotation.y = lerp_angle(self.model.rotation.y, look_direction.angle() + PI/2.0, 
											self.RotationSpeed)


func update_weapon():
	self.current_weapon = self.weapon_hand.get_children()[-1]
	self.current_weapon.update_owner(self.player_id)


func hitbox_got_hit(enemy_id):
	self.emit_signal("got_hit", self.player_id, enemy_id)


func reset_player():
	GameManager.give_points(self.player_id, -1)
	self.global_position = Vector3(randf_range(-5, 5), 5.0, randf_range(-5, 5))
	self.linear_velocity = Vector3(0, 0, 0)


func change_state(new_state):
	self.char_model.animation_player.speed_scale = 1.0
	if self.current_weapon.block_player_movement:
		return
	if new_state == PlayerStates.JUMP:
		self.ground_cast.force_raycast_update()
		if not self.ground_cast.is_colliding():
			return
	self.current_state = new_state
	self.start_state = true
	self.physics_material_override.friction = 1.0


func idle_state():
	self.char_model.animation_player.play("Idle")
	self.direction.x = - MultiplayerInput.get_action_strength(self.player_id, "Left") \
							+ MultiplayerInput.get_action_strength(self.player_id, "Right")
	self.direction.y = - MultiplayerInput.get_action_strength(self.player_id, "Forward") \
							+ MultiplayerInput.get_action_strength(self.player_id, "Backward")
	if not self.direction == Vector2.ZERO or self.linear_velocity.length_squared() > self.IdleThreshold:
		self.change_state(PlayerStates.MOVE)
	elif not self.ground_cast.is_colliding():
		self.change_state(PlayerStates.FALL)


func move_state():
	self.char_model.animation_player.play("Walking_A")
	if self.start_state:
		self.run_trail.restart()
		self.start_state = false
	
	if self.ground_cast.is_colliding():
		self.linear_velocity.y = 0.0
		var current_speed = self.input_movement(self.max_speed, self.acceleration)
		self.char_model.animation_player.speed_scale = min(3.0, 1.5*current_speed/self.max_speed)
	else:
		self.change_state(PlayerStates.FALL)
		return
	
	if self.direction == Vector2.ZERO and self.linear_velocity.length_squared() < self.IdleThreshold:
		self.linear_velocity = Vector3.ZERO
		self.change_state(PlayerStates.IDLE)


func jump_state():
	self.physics_material_override.friction = 0.0
	self.char_model.animation_player.play("Jump_Idle")
	if self.ground_cast.is_colliding() and self.linear_velocity.y < 1.0 and not self.start_state:
		self.change_state(PlayerStates.MOVE)
		self.linear_velocity.x = 0.5*self.old_velocity_xz.x
		self.linear_velocity.z = 0.5*self.old_velocity_xz.y
		
	if self.start_state:
		self.jump_trail_particles.emitting = true
		self.apply_central_impulse(jump_impulse * Vector3(0.0, 1.0, 0.0))
		self.start_state = false
	
	self.old_velocity_xz = Vector2(self.linear_velocity.x, self.linear_velocity.z)
	self.input_movement(0.8*self.max_speed, 2.0*self.acceleration)


func input_movement(max_velo, acc):
	self.direction.x = - MultiplayerInput.get_action_strength(self.player_id, "Left") \
							+ MultiplayerInput.get_action_strength(self.player_id, "Right")
	self.direction.y = - MultiplayerInput.get_action_strength(self.player_id, "Forward") \
							+ MultiplayerInput.get_action_strength(self.player_id, "Backward")

	self.direction = self.direction.rotated(self.direction_rot)

	# Add impuls if not to fast
	var horizontal_velocity = Vector2(self.linear_velocity.x, self.linear_velocity.z)
	var current_speed = horizontal_velocity.length() 
	if current_speed < max_velo:
		var input_strength = self.direction.length()
		self.direction = min(1.0, input_strength) * self.direction.normalized()
		self.apply_central_impulse(acc * Vector3(self.direction.x, 0.0, self.direction.y))
	return current_speed

func attack_state():
	self.char_model.animation_player.speed_scale = 3.5
	self.char_model.animation_player.play("Throw")
	if not self.current_weapon.block_player_movement:
		self.change_state(PlayerStates.IDLE)


func fall_state():
	self.physics_material_override.friction = 0.0
	self.char_model.animation_player.play("Jump_Idle")
	self.input_movement(self.max_speed, self.acceleration)
	if self.ground_cast.is_colliding():
		self.change_state(PlayerStates.MOVE)


func reset_modifiers():
	max_speed = OriginalSpeed
	acceleration = OriginalAcc
	knockback_mod = OriginalKnockbackModifier
