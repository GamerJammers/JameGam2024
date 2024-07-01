extends HBoxContainer


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
		add_child(item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
