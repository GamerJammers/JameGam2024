extends Node

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # "ui_cancel" is mapped to ESCAPE by default in Godot
		get_tree().quit()
