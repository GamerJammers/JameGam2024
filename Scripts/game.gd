extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player
@onready var enemies = $Enemies
@onready var enemySpawner = $EnemySpawner

#@onready var asteroids = $Asteroids
#@onready var hud = $UI/HUD
#@onready var game_over_screen = $UI/GameOverScreen
#@onready var player_spawn_pos = $PlayerSpawnPos
#@onready var player_spawn_area = $PlayerSpawnPos/PlayerSpawnArea

var junk: int = 50
var currency: int = 0
var enemy_grunt = preload("res://scenes/enemy_grunt.tscn")
#var asteroid_scene = preload("res://scenes/asteroid.tscn")

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
	
	var grunt = enemy_grunt.instantiate()
	grunt.global_position = enemySpawner.global_position
	grunt.set_player(player)
	enemies.add_child(grunt)
	
	player.connect("laser_shot", _on_player_laser_shot)
	player.connect("died", _on_player_died)

func _on_player_laser_shot(laser):
	$LaserSound.play()
	lasers.add_child(laser)

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

