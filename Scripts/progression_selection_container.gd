extends HBoxContainer

signal item_selection(selected, value)

const ProgressionItem = preload("res://Scripts/progression_item.gd")


# Called when the node enters the scene tree for the first time.
func _ready():
	var items_selected = []
	
	while len(items_selected) < 3:
		var selected = ProgressionItem.random_item()

		if items_selected.has(selected):
			continue
		
		var item = ProgressionItem.new_progression_item(selected)
		items_selected.append(selected)
		item.connect("item_selection", _on_item_selected)
		add_child(item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_item_selected(selected, value):
	print("progression selected ", selected, value)
	emit_signal("item_selection", selected, value)
