using System;

namespace Day11
{
	class Program
	{
		static void Main(string[] args)
		{
			Password p = new Password("hepxcrrq");
			while (!p.IsValid())
			{
				p.Increment();
			}
			Console.WriteLine($"Part 1: {p.Value}");

			p.Increment();
			while (!p.IsValid())
			{
				p.Increment();
			}
			Console.WriteLine($"Part 2: {p.Value}");

			Console.ReadKey();
		}
	}
}
