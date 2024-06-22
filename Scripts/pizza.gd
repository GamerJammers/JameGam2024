extends RigidBody2D

var speed = 400
var angular_speed = PI

var thrust = Vector2(0, -500)
var torque = 20000
var max_velocity = 750

var canShootInterval = .5
var canShootTimeout = 10000

var cannon

@onready var collision2D = $Collision2D
@onready var boosterLeft = $BoosterLeft
@onready var boosterRight = $BoosterRight

func _process(delta):
	canShootTimeout += delta

	if Input.is_action_pressed("ui_select"):
		shoot()

func _integrate_forces(state):
	var pressing_up = Input.is_action_pressed("ui_up")
	var pressing_down = Input.is_action_pressed("ui_down")
	var pressing_right = Input.is_action_pressed("ui_right")
	var pressing_left = Input.is_action_pressed("ui_left")

	if pressing_up and linear_velocity.length() <= max_velocity:
		state.apply_force(thrust.rotated(rotation))
	elif pressing_down and linear_velocity.length() <= max_velocity:
		state.apply_force(-thrust.rotated(rotation))
	else:
		state.apply_force(Vector2())

	var rotation_direction = 0
	if pressing_right:
		rotation_direction += 1
		boosterRight.emitting = true  
	if pressing_left:
		rotation_direction -= 1
		boosterLeft.emitting = true  

	state.apply_torque(rotation_direction * torque)

	boosterLeft.emitting = pressing_down or pressing_up or pressing_left 
	boosterRight.emitting = pressing_down or pressing_up or pressing_right

func shoot():
	if canShootTimeout > canShootInterval:
		canShootTimeout = 0;

		var rigid_body = RigidBody2D.new()
		var collision_shape = CollisionShape2D.new()
		var shape = CircleShape2D.new()
		shape.radius = 20
		collision_shape.shape = shape

		var sprite = Sprite2D.new()
		var texture = preload("res://sprites/pepperoni.png")  # Load a texture
		sprite.texture = texture
		sprite.z_index = -1

		rigid_body.add_child(collision_shape)
		rigid_body.add_child(sprite)
		rigid_body.set_collision_layer_value(1, false)
		rigid_body.set_collision_layer_value(3, true)

		get_tree().get_root().add_child(rigid_body)
		
		var direction_vector = Vector2.UP.rotated(rotation)
		var target_position = position + direction_vector * 1  # 1 unit above

		# Optionally, set initial position and properties
		rigid_body.position = target_position  # Set initial position
		rigid_body.mass = 0.2  # Set mass
		rigid_body.apply_impulse(linear_velocity + direction_vector * 1000, target_position)
		rigid_body.linear_damp = 0
		rigid_body.angular_damp = 0
