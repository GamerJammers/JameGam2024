class_name Player extends RigidBody2D

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

func _ready():
	max_contacts_reported = 1

func _integrate_forces(state):
	if !alive: return

	if Input.is_action_pressed("ui_up"):
		state.apply_force(thrust.rotated(rotation))
	elif Input.is_action_pressed("ui_down"):
		state.apply_force(-thrust.rotated(rotation))
	else:
		state.apply_force(Vector2())
	var rotation_direction = 0
	if Input.is_action_pressed("ui_right"):
		rotation_direction += 1
	if Input.is_action_pressed("ui_left"):
		rotation_direction -= 1
	state.apply_torque(rotation_direction * torque)
	
	if linear_velocity.length() >= max_velocity:
		linear_velocity = linear_velocity.normalized() * max_velocity

func _process(delta):
	if !alive: return
	
	if Input.is_action_pressed("ui_select"):
		if !shoot_cd:
			shoot_cd = true
			shoot_laser()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false


func _physics_process(delta):
	if !alive: return
	
	var screen_size = get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0

func shoot_laser():
	var l = laser_scene.instantiate()
	l.global_position = cannon.global_position
	l.rotation = rotation
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
