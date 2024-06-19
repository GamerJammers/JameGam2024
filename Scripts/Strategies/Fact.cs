using System;

public class Fact
{
	public string Name { get; set; }

	public Type Type => Value.GetType();

	public object Value { get; set; }
}
