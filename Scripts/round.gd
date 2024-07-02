extends Node  # Using Resource as the base class is lightweight for data containers

var Portal = preload("res://Scripts/portal.gd")
var enemy_grunt = preload("res://scenes/enemy_grunt.tscn")
var enemy_grunt2 = preload("res://scenes/enemy_grunt2.tscn")
var progression_scene = preload("res://scenes/progression_selection.tscn")

@onready var label = $UI/Label
@onready var lasers = $Lasers
@onready var player = $Player
@onready var enemies = $Enemies
@onready var enemySpawner = $EnemySpawner
@onready var portals = $Portals

# Declare member variables and their initial values
var _round_number = 0
var _grunt_total = 0
var _elite_total = 0
var _heavy_total = 0

var _grunt_portal_total = 0 
var _elite_portal_total = 0 
var _heavy_portal_total = 0 

var current_wave := 0
var enemies_to_spawn := []
var MAX_WAVES = 4

func _ready():
	#game_over_screen.visible = false
	label.text = "Round: %s" % String.num(_round_number)
	
	player.connect("laser_shot", _on_player_laser_shot)
	player.connect("died", _on_player_died)
	
	print("round on ready called")
	
	start_next_wave()

func start(number: int):
	print("round on start called")
	
	_round_number = number
	
	_grunt_total = _round_number
	_elite_total = floor(_round_number / 5)
	_heavy_total = floor(_round_number / 10)
	
	_grunt_portal_total = floor(_round_number / 10)
	_elite_portal_total = floor(_round_number / 15)
	_heavy_portal_total = floor(_round_number / 10)

func wave_clear():
	return _grunt_total == 0 and _elite_total == 0 and _heavy_total == 0



func start_next_wave():
	current_wave += 1
	generate_wave_enemies()
	spawn_next_enemy()

func generate_wave_enemies():
	enemies_to_spawn.clear()

	if current_wave == 1:
		enemies_to_spawn = [enemy_grunt2, enemy_grunt]
	elif current_wave == 2:
		enemies_to_spawn = [enemy_grunt, enemy_grunt2, enemy_grunt]


func spawn_next_enemy():
	if enemies_to_spawn.size() > 0:
		var enemy_scene = enemies_to_spawn.pop_front()
		var enemy = enemy_scene.instantiate()
		enemy.global_position = enemySpawner.global_position
		enemy.set_player(player)
		enemy.connect("died", _grunt_died)
		enemy.connect("laser_collided", _laser_collided)
		enemies.add_child(enemy)


func _grunt_died():
	if wave_clear():
		if current_wave >= MAX_WAVES:
			get_tree().change_scene_to_file("res://scenes/progression_selection.tscn")
		else:
			start_next_wave()
	else:
		spawn_next_enemy()

func create_portals():
	var portal = Portal.new_portal(Color(0,0,1))
	portals.add_child(portal)

func _on_player_laser_shot(laser):
	$LaserSound.play()
	lasers.add_child(laser)

func _laser_collided():
	$LaserColliding.play()

func _on_player_died():
	pass
	#$PlayerDieSound.play()
	#lives -= 1
	#player.global_position = player_spawn_pos.global_position
	#if lives <= 0:
		#await get_tree().create_timer(2).timeout
		#game_over_screen.visible = true
	#else:
		#await get_tree().create_timer(1).timeout
		#while !player_spawn_area.is_empty:
			#await get_tree().create_timer(0.1).timeout
		#player.respawn(player_spawn_pos.global_position)

func _process(delta):
	pass
