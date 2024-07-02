extends Node

var Round = preload("res://Scripts/round.gd")
var Portal = preload("res://Scripts/portal.gd")
var enemy_grunt = preload("res://scenes/enemy_grunt.tscn")
var enemy_grunt2 = preload("res://scenes/enemy_grunt2.tscn")
var progression_scene = preload("res://scenes/progression_selection.tscn")

@onready var lasers = $Lasers
@onready var player = $Player
@onready var enemies = $Enemies
@onready var enemySpawner = $EnemySpawner
@onready var portals = $Portals

var round = Round.new()

var current_wave := 0
var enemies_to_spawn := []
var score := 0
var lives := 3

func _ready():
	#game_over_screen.visible = false
	score = 0
	lives = 3

	#create_portals()
	
	round.start()
	spawn_enemies()

	player.connect("laser_shot", _on_player_laser_shot)
	player.connect("died", _on_player_died)
	start_next_wave()

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
	round.grunt_died()
	var MAX_WAVES = 4
	if round.wave_clear():
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
	#$PlayerDieSound.play()
	lives -= 1
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
