extends Resource  # Using Resource as the base class is lightweight for data containers

class_name RoundStruct  # This allows the class to be globally recognized

# Declare member variables and their initial values
var _round_number = 1 
var _grunt_number = 2
var _elite_number = 0
var _heavy_number = 0

func _init():
	pass

func start():
	_grunt_number = _round_number
	_elite_number = floor(_round_number / 5)
	_heavy_number = floor(_round_number / 10)

func grunt_total():
	_round_number 

func grunt_died():
	_grunt_number -= 1

func wave_clear():
	return _grunt_number == 0 and _elite_number == 0 and _heavy_number == 0
