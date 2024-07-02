class_name Portal extends Node2D

signal create_enemy(portal)

const my_scene: PackedScene = preload("res://scenes/portal.tscn")

@onready var animationSprite2D = $AnimatedSprite2D
@export var color: Color 

var _alive = false 
var _total_enemies = 0 

# Called when the node enters the scene tree for the first time.
func _ready():
	animationSprite2D.play("default")
	animationSprite2D.modulate = color 

func enemy_still_alive():
	return _alive

func enemy_died():
	_alive = false
	_total_enemies -= 1
	
func set_color(c: Color):
	color = c 
	
func total_enemies(total: int):
	_total_enemies = total

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _total_enemies == 0:
		queue_free()
		return 
	
	if enemy_still_alive():
		return 
	else:
		_alive = true 
		emit_signal("create_enemy", self)
	
