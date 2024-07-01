class_name Player extends CharacterBody2D

signal laser_shot(laser)
signal died

@export var acceleration := 10.0
@export var max_speed := 350.0
@export var rotation_speed := 250.0

@onready var cannon = $Cannon
@onready var sprite = $Sprite2D
@onready var cshape = $CollisionPolygon2D

var laser_scene = preload("res://scenes/laser.tscn")

var shoot_cd = false
var rate_of_fire = 0.15
var max_velocity = 1000

var alive := true
var thrust = Vector2(0, -250)
var torque = 20000
#
#func _ready():
	#max_contacts_reported = 1

func _physics_process(delta):
	if !alive: return
	
	var input_vector = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		input_vector.y = -1
	elif Input.is_action_pressed("ui_down"):
		input_vector.y = 1
	else:
		input_vector.y = 0
	
	if Input.is_action_pressed("ui_left"):
		input_vector.x = -1
	elif Input.is_action_pressed("ui_right"):
		input_vector.x = 1
	else:
		input_vector.x = 0

	print(input_vector)

	look_at(get_global_mouse_position())
	rotate(deg_to_rad(90))
	
	velocity += input_vector.rotated(rotation) * acceleration
	velocity = velocity.limit_length(max_speed)
	
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)
	
	move_and_slide()
	
	var screen_size = get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0

func _process(delta):
	if !alive: return
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):  # Check if left mouse button is pressed
		if !shoot_cd:
			shoot_cd = true
			shoot_laser()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false



func shoot_laser():
	var l = laser_scene.instantiate()
	var mouse_pos = get_global_mouse_position()  # Get global mouse position
	print("Mouse position: ", mouse_pos)  
	l.global_position = cannon.global_position
	l.look_at(mouse_pos)
	l.rotate(deg_to_rad(90))
	emit_signal("laser_shot", l)

func die():
	if alive==true:
		alive = false
		sprite.visible = false
		cshape.set_deferred("disabled", true)
		emit_signal("died")

func respawn(pos):
	if alive==false:
		alive = true
		global_position = pos
		sprite.visible = true
		cshape.set_deferred("disabled", false)
