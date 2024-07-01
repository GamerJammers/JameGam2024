class_name Laser extends Area2D

@export var speed := 500.0
var movement_vector := Vector2(0, -1)

func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func power():
	return 25

func _on_body_entered(body):
	var grunt: EnemyGrunt = body as EnemyGrunt
	if grunt:
		grunt.take_damage(power())
	
	queue_free()
		
	
	
