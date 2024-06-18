extends Sprite2D

var speed = 400
var angular_speed = PI

func _process(delta):
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1

	rotation += angular_speed * direction * delta

	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity = Vector2.UP.rotated(rotation) * speed
	elif Input.is_action_pressed("ui_down"):
		velocity = -Vector2.UP.rotated(rotation) * speed * speed # So that if you hit the down key, zoom zoom off the screen forever!!!  mwahaha

	position += velocity * delta