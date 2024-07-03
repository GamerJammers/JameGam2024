class_name Player extends CharacterBody2D

signal laser_shot(laser)
signal damage_taken(health)
signal died


@onready var cannon = $Cannon
@onready var sprite = $Sprite2D
@onready var cshape = $CollisionPolygon2D

var laser_scene = preload("res://scenes/laser.tscn")

var shoot_cd = false

var _alive := true
var _health
var _max_speed
var _rate_of_fire
var _acceleration
var _power 
var _damage = false 
var _fade_time = 0.01
var _elapsed_time = 0.0
var _start_color = Color(1, 0, 0, 1)  # Red color
var _end_color = Color(1, 1, 1, 1)  # Normal color
var _orig_collision_mask 
var _orig_collision_layer

func init(health: float, power: float, damage_timeout: float, max_speed: float, acceleration: float, rate_of_fire: float):
	_alive = true
	_damage = false 
	_health = health
	_power = power 
	_fade_time = damage_timeout
	_elapsed_time = 0
	_max_speed = max_speed
	_acceleration = acceleration
	_rate_of_fire = rate_of_fire

func _ready():
	_orig_collision_mask = collision_mask
	_orig_collision_layer = collision_layer

func _physics_process(delta):
	if !_alive: return
	
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

	look_at(get_global_mouse_position())
	rotate(deg_to_rad(90))
	
	velocity += input_vector * _acceleration
	velocity = velocity.limit_length(_max_speed)
	
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
	if !_alive: return
	
	if _damage:
		if _elapsed_time < _fade_time:
			_elapsed_time += delta
			sprite.modulate = lerp(_start_color, _end_color, _elapsed_time / _fade_time)
		else:
			collision_mask = _orig_collision_mask
			collision_layer = _orig_collision_layer
			sprite.modulate = _end_color
			_damage = false  
			
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):  # Check if left mouse button is pressed
		if !shoot_cd:
			shoot_cd = true
			shoot_laser()
			await get_tree().create_timer(_rate_of_fire).timeout
			shoot_cd = false

func shoot_laser():
	var l = laser_scene.instantiate()
	var mouse_pos = get_global_mouse_position()  # Get global mouse position
	l.set_power(_power)
	l.global_position = cannon.global_position
	l.look_at(mouse_pos)
	l.rotate(deg_to_rad(90))
	emit_signal("laser_shot", l)

func take_damage(amount):
	if _damage: return
	_damage = true 
	_elapsed_time = 0 
	_health -= amount 
	collision_mask = 0 
	collision_layer = 0 
	emit_signal("damage_taken", _health)
	if _health <= 0:
		die()
		
func die():
	_alive = false
	sprite.visible = false
	cshape.set_deferred("disabled", true)
	emit_signal("died")
