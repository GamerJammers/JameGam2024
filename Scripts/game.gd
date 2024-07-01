extends Node2D

var Round = preload("res://Scripts/round.gd")
var Portal = preload("res://Scripts/portal.gd")
var enemy_grunt = preload("res://scenes/enemy_grunt.tscn")

@onready var lasers = $Lasers
@onready var player = $Player
@onready var enemies = $Enemies
@onready var enemySpawner = $EnemySpawner
@onready var portals = $Portals
@onready var round = Round.new()

var score := 0:
	set(value):
		score = value
		#hud.score = score

var lives: int:
	set(value):
		lives = value
		#hud.init_lives(lives)

func _ready():
	#game_over_screen.visible = false
	score = 0
	lives = 3

	#create_portals()
	spawn_grunt()

	player.connect("laser_shot", _on_player_laser_shot)
	player.connect("died", _on_player_died)

func spawn_grunt():
	var grunt = enemy_grunt.instantiate()
	grunt.global_position = enemySpawner.global_position
	grunt.set_player(player)
	grunt.connect("died", _grunt_died)
	grunt.connect("laser_collided", _laser_collided)
	enemies.add_child(grunt)

func _grunt_died():
	round.grunt_died()
	
	if !round.wave_clear():
		spawn_grunt()
	else:
		get_tree().change_scene_to_file("res://scenes/progression_selection.tscn")

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
