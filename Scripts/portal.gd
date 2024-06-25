class_name Portal extends Node2D

const my_scene: PackedScene = preload("res://scenes/portal.tscn")

@onready var animationSprite2D = $AnimatedSprite2D

@export var color: Color 

static func new_portal(c: Color):
	var portal: Portal = my_scene.instantiate()
	portal.color = c 
	return portal 

# Called when the node enters the scene tree for the first time.
func _ready():
	animationSprite2D.play("default")
	animationSprite2D.modulate = color 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
