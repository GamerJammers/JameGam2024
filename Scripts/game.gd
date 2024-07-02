extends Node

const round_scene: PackedScene = preload("res://scenes/round.tscn")

var round_number = 1 # start on round 1

func _ready():
	start_round()

func start_round():
	var round = round_scene.instantiate()
	round.start(round_number)
	add_child(round)
	pass
