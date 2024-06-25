extends Resource  # Using Resource as the base class is lightweight for data containers

class_name LevelStruct  # This allows the class to be globally recognized

# Declare member variables and their initial values
var _number = 1 
var _grunt_number = 0
var _elite_number = 0
var _heavy_number = 0

func _init(number: int, grunt_number: int, elite_number: int, heavy_number: int):
	_grunt_number = grunt_number
	_elite_number = elite_number
	_heavy_number = heavy_number

func grunt_died():
	_grunt_number -= 1

func wave_clear():
	return _grunt_number == 0 and _elite_number == 0 and _heavy_number == 0
