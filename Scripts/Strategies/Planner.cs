using System.Collections.Generic;
using System.Linq;
using static StrategyBuilder;

public static class Planner
{
	public static Queue<Strategy> Plan(List<Strategy> options, List<Fact> currentState, Fact goal)
	{
		Queue<Strategy> plan = new();

		List<Fact> temporaryState = new();
		temporaryState.AddRange(currentState);

		int count = 0;
		bool found = false;
		while(!found && count++ < 100)
		{
			var nextStep = options.Where(x => x.Effects.Contains(goal));
			


		}

		return plan;
	}
}
