extends RigidBody2D

var speed = 400
var angular_speed = PI

var thrust = Vector2(0, -250)
var torque = 20000

func shoot():
	if timePassed > (bananas/1000) + .2:
		timePassed = 0;
		
		var rigid_body = RigidBody2D.new()
		var collision_shape = CollisionShape2D.new()
		var shape = CircleShape2D.new()
		shape.radius = 20
		collision_shape.shape = shape
		
		var sprite = Sprite2D.new()
		var texture = preload("res://space_laser.png")  # Load a texture
		sprite.texture = texture
		
		rigid_body.add_child(collision_shape)
		rigid_body.add_child(sprite)
	
		get_tree().get_root().add_child(rigid_body)
		
		var direction_vector = Vector2.UP.rotated(rotation)
		var target_position = position + direction_vector * 90.0  # 1 unit above
		
		# Optionally, set initial position and properties
		rigid_body.position = target_position  # Set initial position
		rigid_body.mass = 1.0  # Set mass
		rigid_body.apply_impulse(linear_velocity + direction_vector * 1000, target_position)
		rigid_body.linear_damp = 0
		rigid_body.angular_damp = 0

var bananas = 300
var timePassed = 10000

func _process(delta):
	timePassed += delta
	
	if Input.is_action_pressed("ui_select"):
		shoot()

func _integrate_forces(state):
	if Input.is_action_pressed("ui_up"):
		state.apply_force(thrust.rotated(rotation))
	else:
		state.apply_force(Vector2())
		
	var rotation_direction = 0
	if Input.is_action_pressed("ui_right"):
		rotation_direction += 1
	if Input.is_action_pressed("ui_left"):
		rotation_direction -= 1
		
	state.apply_torque(rotation_direction * torque)
