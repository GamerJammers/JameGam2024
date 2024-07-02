extends Node

const round_scene: PackedScene = preload("res://scenes/round.tscn")
const progress_scene: PackedScene = preload("res://scenes/progression_selection.tscn")

var round_number = 1 # start on round 1
var health = 100
var power = 25 

@onready var labelRound = $UI/VBoxContainer/LabelRound
@onready var labelHealth = $UI/VBoxContainer/LabelHealth
@onready var labelPower = $UI/VBoxContainer/LabelPower

var round
var progress

func _ready():
	set_labels()
	start_round()

func set_labels():
	labelRound.text = "Round: %s" % String.num(round_number)
	labelHealth.text = "Health: %s%%" % String.num(health)
	labelPower.text = "Power: %s" % String.num(power)

func start_round():
	if progress:
		remove_child(progress)
	
	round = round_scene.instantiate()
	round.start(round_number, health, power)
	round.connect("lost_health", _on_lost_health)
	round.connect("round_completed", _on_round_completed)
	round.connect("game_over", _on_game_over)
	add_child(round)
	pass

func _on_lost_health(damage: int):
	health -= damage 
	set_labels()
	print("lost health!")
	pass

func _on_round_completed():
	print("round completed!")
	remove_child(round)
	progress = progress_scene.instantiate()
	progress.connect("item_selection", _on_item_selection)
	add_child(progress)

func _on_item_selection(item, value):
	print("item selected ", item, value)
	round_number += 1
	set_labels()
	start_round()
	pass

func _on_game_over():
	print("game ended!")
	pass
