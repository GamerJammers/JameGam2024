extends Camera2D

var playerBody

# Called when the node enters the scene tree for the first time.
func _ready():
	playerBody = get_node("../RigidBody2D")
	print(playerBody)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#position = playerSprite.position
	position.x = playerBody.position.x
	position.y = playerBody.position.y
	pass
