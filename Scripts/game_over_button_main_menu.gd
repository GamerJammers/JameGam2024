extends Button

func _ready():
	# Connect the button's "pressed" signal to the handler function
	connect("pressed", Callable(self, "_on_Button_pressed"))

func _on_Button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
