extends Node

# Reference to the C# script node
onready var csharp_node = $MyCSharpScript

# GDScript method to be called from C#
func gdscript_method(message):
	print("GDScript Method called with message: ", message)

# This method calls the C# method
func call_csharp_method():
	csharp_node.CSharpMethod("Hello from GDScript")

# Connect the signal from C#
func _ready():
	print("GDScript ready!")
	csharp_node.connect("CSharpSignal", self, "_on_csharp_signal")
	call_csharp_method()
	# Call a method in C#
	csharp_node.CallGDScriptMethod(self, "gdscript_method")

# Signal handler
func _on_csharp_signal(message):
	print("Signal received from C#: ", message)
