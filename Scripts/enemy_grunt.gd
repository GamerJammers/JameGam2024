class_name EnemyGrunt extends RigidBody2D

signal died
signal laser_collided
signal player_collided_grunt(player)

@onready var sprite = $Sprite2D

var _alive := true
var _damage = false 
var _player = null 
var _health = 100 
var _max_velocity = 0
var _fade_time = 0.01
var _elapsed_time = 0.0
var _rate_of_finding = 0.0
var _time_since_finding = 100000 # set large for initial so it resets initially
var _body_damage = 0
var _start_color = Color(1, 0, 0, 1)  # Red color
var _end_color = Color(1, 1, 1, 1)  # Normal color
var _orig_collision_mask 
var _orig_collision_layer

func init(health: float, max_velocity: float, damage_timeout: float, rate_of_finding: float, body_damage: float, player: Player):
	_alive = true
	_damage = false 
	_health = health
	_max_velocity = max_velocity
	_fade_time = damage_timeout
	_elapsed_time = 0
	_rate_of_finding = rate_of_finding
	_body_damage = body_damage 
	_player = player 
	
func take_damage(amount):
	if _damage: return
	_damage = true 
	_elapsed_time = 0 
	_health -= amount 
	collision_mask = 0 
	collision_layer = 0 
	linear_velocity = Vector2(0,0)
	emit_signal("laser_collided")
	if _health <= 0:
		die()

func die():
	if _alive==true:
		_alive = false
		queue_free()
		emit_signal("died")

func _ready():
	_orig_collision_mask = collision_mask
	_orig_collision_layer = collision_layer
	max_contacts_reported = 1
	contact_monitor = true 
	
func _process(delta):
	if _damage:
		if _elapsed_time < _fade_time:
			_elapsed_time += delta
			sprite.modulate = lerp(_start_color, _end_color, _elapsed_time / _fade_time)
		else:
			collision_mask = _orig_collision_mask
			collision_layer = _orig_collision_layer
			sprite.modulate = _end_color
			_damage = false  
	
func _physics_process(delta):
	_time_since_finding += delta 
	
	if linear_velocity.length() >= _max_velocity:
		linear_velocity = linear_velocity.normalized() * _max_velocity
		
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
	if _damage: return
	
	if _time_since_finding >= _rate_of_finding:
		_time_since_finding = 0
		var direction = (_player.global_position - global_position).normalized()
		apply_central_impulse(direction * 200)
		
	for i in range(state.get_contact_count()):
		var contact_position: Vector2 = state.get_contact_local_position(i)
		var contact_normal: Vector2 = state.get_contact_local_normal(i)
		var contact_body: Object = state.get_contact_collider_object(i)

		if contact_body:
			var colliding_body: RigidBody2D = contact_body as RigidBody2D
			if contact_body is Player:
				var player = contact_body as Player
				take_damage(_body_damage)
				player.take_damage(_body_damage)
				#emit_signal("player_collided_grunt", player)
				
		
