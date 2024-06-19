using Godot;
using System;

public partial class MyCSharpScript : Node
{
	// Signal definition
	[Signal]
	public delegate void CSharpSignalEventHandler(string message);

	// This method will be called from GDScript
	public void CSharpMethod(string message)
	{
		GD.Print("C# Method called with message: " + message);
		EmitSignal(nameof(CSharpSignal), "Hello from C#");
	}
	
	// This method will call a GDScript method
	public void CallGDScriptMethod(Node target, string methodName)
	{
		target.Call(methodName, "Hello from C# to GDScript");
	}
	
	public override void _Ready()
	{
		GD.Print("C# script ready!");
	}
}
