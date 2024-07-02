extends Node2D  # Using Resource as the base class is lightweight for data containers

signal round_completed
signal lost_health 
signal game_over

var enemy_drumstick = preload("res://scenes/enemy_drumstick.tscn")
var enemy_calzone = preload("res://scenes/enemy_calzone.tscn")
var enemy_breadstick = preload("res://scenes/enemy_breadstick.tscn")
var progression_scene = preload("res://scenes/progression_selection.tscn")
var portal_scene = preload("res://scenes/portal.tscn")
var player_scene = preload("res://scenes/player.tscn")

@onready var lasers = $Lasers
@onready var enemies = $Enemies
@onready var enemySpawner = $EnemySpawner
@onready var portals = $Portals

# Declare member variables and their initial values
var _round_number = 0
var _grunt_total = 0
var _elite_total = 0
var _heavy_total = 0

#var _grunt_portal_total = 0 
#var _elite_portal_total = 0 
#var _heavy_portal_total = 0 

var current_wave := 0
var enemies_to_spawn := []
var MAX_WAVES = 4
var rng = RandomNumberGenerator.new()
var player

func start(number: int, health: int, power: int):
	print("round on start called with ", number)
	
	_round_number = number
	
	_grunt_total = _round_number
	_elite_total = floor(_round_number / 5)
	
	player = player_scene.instantiate()
	player.init(health, power)
	player.connect("laser_shot", _on_player_laser_shot)
	player.connect("died", _on_player_died)
	
	_heavy_total = floor(_round_number / 10)
	
	#_grunt_portal_total = floor(_round_number / 10) 
	#if _grunt_portal_total < 1:
		#_grunt_portal_total = 1
	#_elite_portal_total = floor(_round_number / 15)
	#_heavy_portal_total = floor(_round_number / 10)

func _ready():
	print("round on ready called")
	var screen_size = get_viewport_rect().size
	player.global_position.x = screen_size.x / 2
	player.global_position.y = screen_size.y / 2
	add_child(player)
	add_portals(_grunt_total, Color(0,1,0), _create_drumstick)
	add_portals(_elite_total, Color(0,0,1), _create_breadstick)
	add_portals(_heavy_total, Color(1,0,0), _create_calzone)

func add_portals(total_enemies: int, color: Color, create_enemy_fn: Callable):
	var screen_size = get_viewport_rect().size
	
	print("adding portal")
	var p = portal_scene.instantiate()
	p.set_color(Color(0,1,0))
	p.total_enemies(total_enemies)
	
	p.global_position.x = rng.randi_range(0, screen_size.x-100)
	p.global_position.y = rng.randi_range(0, screen_size.y-100)
	p.connect("create_enemy", create_enemy_fn)
	portals.add_child(p)

func _create_drumstick(portal):
	var enemy = enemy_drumstick.instantiate()
	enemy.global_position = portal.global_position
	enemy.set_player(player)
	var grunt_died = func():
		portal.enemy_died()
		pass 
	enemy.connect("died", grunt_died)
	enemy.connect("laser_collided", _laser_collided)
	enemies.add_child(enemy)

func _create_calzone(portal):
	var enemy = enemy_drumstick.instantiate()
	enemy.global_position = portal.global_position
	enemy.set_player(player)
	var grunt_died = func():
		portal.enemy_died()
		pass 
	enemy.connect("died", grunt_died)
	enemy.connect("laser_collided", _laser_collided)
	enemies.add_child(enemy)

func _create_breadstick(portal):
	var enemy = enemy_drumstick.instantiate()
	enemy.global_position = portal.global_position
	enemy.set_player(player)
	var grunt_died = func():
		portal.enemy_died()
		pass 
	enemy.connect("died", grunt_died)
	enemy.connect("laser_collided", _laser_collided)
	enemies.add_child(enemy)

var _round_completed = false 
func _process(delta):
	if portals.get_child_count() < 1 and !_round_completed:
		print(portals.get_child_count() < 1, !_round_completed)
		emit_signal("round_completed")
		_round_completed = true 
	
	if portals.get_child_count() < 1:
		return 
		
	pass

func _on_player_laser_shot(laser):
	$LaserSound.play()
	lasers.add_child(laser)

func _laser_collided():
	$LaserColliding.play()

func _on_player_died():
	emit_signal("game_over")


