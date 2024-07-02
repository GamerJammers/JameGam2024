class_name EnemyGrunt extends RigidBody2D

signal died
signal laser_collided
signal player_collided_grunt(player)

var _player = null 
var rate_of_finding = 2
var time_since_finding = 10
var max_velocity = 200
var health = 100 
var alive := true

var damage = false 
var fade_time = 2.0
var elapsed_time = 0.0
var start_color = Color(1, 0, 0, 1)  # Red color
var end_color = Color(1, 1, 1, 1)  # Normal color

@onready var sprite = $Sprite2D

var orig_collision_mask 
var orig_collision_layer

func take_damage(amount):
	if damage: return
	damage = true 
	elapsed_time = 0 
	health -= amount 
	collision_mask = 0 
	collision_layer = 0 
	linear_velocity = Vector2(0,0)
	emit_signal("laser_collided")
	if health <= 0:
		die()

func die():
	if alive==true:
		alive = false
		queue_free()
		emit_signal("died")

func _ready():
	orig_collision_mask = collision_mask
	orig_collision_layer = collision_layer
	max_contacts_reported = 1
	contact_monitor = true 
	
func _process(delta):
	if damage:
		if elapsed_time < fade_time:
			elapsed_time += delta
			var t = elapsed_time / fade_time
			sprite.modulate = lerp(start_color, end_color, t)
		else:
			collision_mask = orig_collision_mask
			collision_layer = orig_collision_layer
			sprite.modulate = end_color
			damage = false  
	
func set_player(player):
	_player = player 
	
func _physics_process(delta):
	time_since_finding += delta 
	
	if linear_velocity.length() >= max_velocity:
		linear_velocity = linear_velocity.normalized() * max_velocity
		
	var screen_size = get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0

func _integrate_forces(state):
	if damage: return
	
	if time_since_finding >= rate_of_finding:
		time_since_finding = 0
		var direction = (_player.global_position - global_position).normalized()
		apply_central_impulse(direction * 200)
		
	for i in range(state.get_contact_count()):
		var contact_position: Vector2 = state.get_contact_local_position(i)
		var contact_normal: Vector2 = state.get_contact_local_normal(i)
		var contact_body: Object = state.get_contact_collider_object(i)

		if contact_body:
			var colliding_body: RigidBody2D = contact_body as RigidBody2D
			
			#apply_central_impulse(colliding_body.linear_velocity.normalized() * colliding_body.mass*3)
			#
			#if contact_body is Player:
				#var player = contact_body as Player
				#take_damage(25)
				#emit_signal("player_collided_grunt", player)
				
		
