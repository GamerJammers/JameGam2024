extends Camera2D

var playerBody

# Called when the node enters the scene tree for the first time.
func _ready():
	playerBody = get_node("../Player/Container/RigidBody2D")

func _physics_process(delta):
	position.x = playerBody.position.x
	position.y = playerBody.position.y
