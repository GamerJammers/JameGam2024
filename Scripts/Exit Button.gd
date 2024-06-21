extends Button

func _ready():
	# Connect the button's "pressed" signal to the handler function
	connect("pressed", Callable(self, "_on_Button_pressed"))

# Function to exit the game
func _on_Button_pressed():
	get_tree().quit()
