extends RichTextLabel

func _ready():
	# Ensure the GameManager is instantiated before trying to use it
	if GameManager != null:
		# Set the text of the RichTextLabel to the score from GameManager
		text = "Junk: %d" % GameManager.junk
	else:
		print("GameManager instance is not available")

# Optional: Update the label every frame if the score can change during gameplay
func _process(delta):
	if GameManager != null:
		text = "Junk: %d" % GameManager.junk
