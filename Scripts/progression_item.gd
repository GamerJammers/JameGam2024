class_name ProgressionItem extends VBoxContainer

signal item_selection(selection, value)

const progression_scene: PackedScene = preload("res://scenes/progression_item.tscn")
const upgrade_pineapple = preload("res://sprites/pizza_upgrade_pineapple.png")
const upgrade_mushrooms = preload("res://sprites/pizza_upgrade_mushrooms.png")
const upgrade_pepperoni = preload("res://sprites/pizza_upgrade_pepperoni.png")
const upgrade_sausage = preload("res://sprites/pizza_upgrade_sausage.png")
const upgrade_extra_cheese = preload("res://sprites/cheesy_particles.png")

@onready var label = $Label
@onready var texture = $TextureRect
@onready var description = $RichTextLabel
@onready var chooseBtn = $Button 
@export var selected: String
@export var value: float 

static var items = [
	"mushroom",  # equals health
	"pineapple", # equals disable ship delay
	"pepperoni", # equals damage increase
	"sausage",   # equals shoot a random sausage every 5 seconds
	#"cheese",    # equals slow or stop time
]

static func new_progression_item(selected: String):
	var item: ProgressionItem = progression_scene.instantiate()
	item.selected = selected
	return item 

static func random_item():
	var rng = RandomNumberGenerator.new()
	return ProgressionItem.items[rng.randi() % items.size()]

func _ready():
	var rng = RandomNumberGenerator.new()
	chooseBtn.text = "Select"
	chooseBtn.pressed.connect(self._button_pressed)
	
	match selected:
		"mushroom": # equals health
			label.text = "Mushroom"
			value = rng.randf_range(10, 30)
			value = round(value * 100) / 100.0
			description.text = "Restore health to full and increase maximum health by %s%%" % value 
			texture.texture = upgrade_mushrooms
		"pineapple": # equals disable enemy ship delay while shooting
			label.text = "Pineapple"
			value = rng.randf_range(0.1, 0.5)
			value = round(value * 100) / 100.0
			description.text = "Increase enemy ship disable timeout by %s" % value 
			texture.texture = upgrade_pineapple
		"pepperoni": # equals damage increase
			label.text = "Pepperoni"
			value = rng.randf_range(10, 20)
			value = round(value * 100) / 100.0
			description.text = "Increase weapon damage by %s%%" % value 
			texture.texture = upgrade_pepperoni
		"sausage": # equals shoot a random sausage every 5 seconds
			label.text = "Sausage"
			value = rng.randf_range(10, 20)
			description.text = "Increase base ship speed by %s%%" % value
			texture.texture = upgrade_sausage
		"cheese": # equals 
			label.text = "Extra Cheese"
			value = rng.randf_range(5, 15)
			value = round(value * 100) / 100.0
			description.text = "Increase ship rate of fire by %s%%" % value
			texture.texture = upgrade_extra_cheese
		_:
			printerr("invalid random item")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _button_pressed():
	print("You chose the topping %s" % selected)
	emit_signal("item_selection", selected, value)
	
