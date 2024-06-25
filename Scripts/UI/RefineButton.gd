extends Button

func _ready():
	# Connect the button's "pressed" signal to the handler function
	connect("pressed", Callable(self, "_on_Button_pressed"))

func _on_Button_pressed():
	if GameManager.junk >= 10:
		GameManager.junk -= 10
		GameManager.currency += 10
		print("Junk: %d, Currency: %d" % [GameManager.junk, GameManager.currency])
	else:
		print("Not enough junk")
