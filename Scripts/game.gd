extends Node

const round_scene: PackedScene = preload("res://scenes/round.tscn")
const progress_scene: PackedScene = preload("res://scenes/progression_selection.tscn")
const game_over_scene: PackedScene = preload("res://scenes/game_over.tscn")

@onready var labelRound = $UI/VBoxContainer/LabelRound
@onready var labelHealth = $UI/VBoxContainer/LabelHealth
@onready var labelPower = $UI/VBoxContainer/LabelPower
@onready var labelTimeout = $UI/UI/VBoxContainer/LabelTimeout
@onready var labelSpeed = $UI/UI/VBoxContainer/LabelSpeed
@onready var labelRateOfFire = $UI/UI/VBoxContainer/LabelRateOfFire

var round
var progress

var _round_number = 1 # start on round 1
var _alive = true
var _max_health = 100.0
var _health = 100.0
var _power = 25.0 
var _enemy_damaged_timeout = 0.20
var _max_speed = 350.0
var _acceleration = 10.0
var _rate_of_fire = 2

func _ready():
	set_labels()
	start_round()

func start_round():
	if progress:
		remove_child(progress)
	
	round = round_scene.instantiate()
	round.init(
		_round_number, 
		_health, 
		_power, 
		_enemy_damaged_timeout, 
		_max_speed,
		_acceleration,
		_rate_of_fire,
		_on_damage_taken
	)
	round.connect("round_completed", _on_round_completed)
	round.connect("game_over", _on_game_over)
	add_child(round)
	pass

func _on_damage_taken(new_health):
	_health = new_health
	_alive = !(_health <= 0)
	set_labels()

func set_labels():
	labelRound.text = "Round: %s" % str(_round_number)
	labelHealth.text = "Health: %s" % str(_health)
	labelPower.text = "Power: %s" % str(_power)
	labelSpeed.text = "Speed: %s" % str(_max_speed)
	labelRateOfFire.text = "Speed: %s" % str(_rate_of_fire)
	labelTimeout.text = "Enemy Timeout: %s" % str(_enemy_damaged_timeout)

func _on_round_completed():
	print("round completed!")
	remove_child(round)
	progress = progress_scene.instantiate()
	progress.connect("item_selection", _on_item_selection)
	add_child(progress)

func _on_item_selection(item, value):
	print("item selected ", item, value)
	_round_number += 1
	match item:
		"mushroom":
			_max_health += _max_health * (value/100)
			_health = _max_health
		"pineapple": # equals disable ship delay
			_enemy_damaged_timeout += _enemy_damaged_timeout * (value/100)
		"pepperoni": # equals damage increase
			_power += _power * (value/100)
		"sausage":  
			_max_speed += _max_speed * (value/100)
		"cheese":  
			_rate_of_fire -= _rate_of_fire * (value/100)
		
	set_labels()
	start_round()
	pass

func _on_game_over():
	print("game ended!")
	pass

func _process(delta):
	if !_alive:
		if progress:
			remove_child(progress)
		add_child(game_over_scene.instantiate())
		return
