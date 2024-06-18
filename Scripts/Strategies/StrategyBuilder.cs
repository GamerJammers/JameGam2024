using System;
using System.Collections.Generic;

public static class StrategyBuilder
{
	public sealed class Strategy
	{
		public string Name { get; set; }

		public Action Action { get; set; }

		public int Priority { get; set; }

		public List<Fact> Requirements { get; set; } = new();

		public List<Fact> Effects { get; set; } = new();

		//private Strategy() { } //so that it can't be created without the builder

		public override string ToString() => $"Strategy: {Name}\nRequirements: {string.Join(", ", Requirements)}\nEffects: {string.Join(", ", Effects)}";
	}

	public static ISetName CreateStrategy() => new Build();

	public interface ISetName
	{
		public abstract ISetPriority IsNamed(string name);
	}

	public interface ISetPriority
	{
		public abstract ISetRequirements IsPriority(int priority);
	}

	public interface ISetRequirements
	{
		public abstract ISetEffects HasRequirements(List<Fact> requirements);

		public abstract ISetEffects NoRequirements();
	}

	public interface ISetEffects
	{
		public abstract IBuild CausesEffects(List<Fact> effects);

		public abstract IBuild NoEffects();
	}

	public interface IBuild
	{
		public abstract Strategy Build();
	}

	private class Build : ISetName, ISetPriority, ISetRequirements, ISetEffects, IBuild
	{
		private readonly Strategy strategy = new();

		public ISetPriority IsNamed(string name)
		{
			strategy.Name = name;
			return this;
		}

		public ISetRequirements IsPriority(int priority)
		{
			strategy.Priority = priority;
			return this;
		}

		public ISetEffects HasRequirements(List<Fact> requirements)
		{
			strategy.Requirements = requirements;
			return this;
		}
		public ISetEffects NoRequirements() => this;

		public IBuild CausesEffects(List<Fact> effects)
		{
			strategy.Effects = effects;
			return this;
		}
		public IBuild NoEffects() => this;

		Strategy IBuild.Build() => strategy;
	}
}
