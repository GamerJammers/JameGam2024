extends Node

signal item_selection(selected, value)

@onready var container = $CenterContainer/VBoxContainer/CenterContainer/HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	container.connect("item_selection", _on_item_selected)

func _on_item_selected(selected, value):
	print("progression selected ", selected, value)
	emit_signal("item_selection", selected, value)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
