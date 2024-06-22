extends RigidBody2D

var _player = null 

func set_player(player):
	_player = player 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
var rate_of_finding = 2
var time_since_finding = 10
var max_velocity = 200
	
func _physics_process(delta):
	time_since_finding += delta 
	if _player != null:
		if time_since_finding >= rate_of_finding:
			time_since_finding = 0
			var direction = (_player.global_position - global_position).normalized()
			print(direction)
			# Apply force in that direction
			apply_central_impulse(direction * 200)
	
	var screen_size = get_viewport_rect().size
	
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0
	
	if linear_velocity.length() > max_velocity:
		linear_velocity = linear_velocity.normalized() * max_velocity
