class_name Laser extends Area2D

@export var speed := 500.0
var movement_vector := Vector2(0, -1)

func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func power():
	return 30

func _on_body_entered(body):
	var grunt: EnemyGrunt = body as EnemyGrunt
	if grunt:
		grunt.take_damage(power())
	else:
		var grunt2: EnemyGrunt2 = body as EnemyGrunt2
		if grunt2:
			grunt2.take_damage(power())
	
	queue_free()
		
	
	
