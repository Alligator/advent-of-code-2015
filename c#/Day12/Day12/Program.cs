using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.IO;
using System.Linq;

namespace Day12
{
	class Program
	{
		static void Main(string[] args)
		{
			string input = File.ReadAllText(@"C:\Users\alligator\dev\aoc2015\12.txt");

			JToken root = JToken.Parse(input);
			int count1 = RecursiveCount(root);
			int count2 = RecursiveCount(root, "red");

			Console.WriteLine($"part 1: {count1}\npart 2: {count2}");
			Console.ReadKey();
		}

		static int RecursiveCount(JToken root, string ignoreKey = null)
		{
			int count = 0;

			switch (root.Type)
			{
				case JTokenType.Object:
					JObject obj = (JObject)root;
					if (ignoreKey != null)
					{
						// look for the ignoreKey and bail
						if (obj.Values().Any(x => x.Type == JTokenType.String && x.ToObject<string>() == ignoreKey))
							return 0;
					}

					foreach (var prop in obj)
					{
						count += RecursiveCount(prop.Value, ignoreKey);
					}
					break;
				case JTokenType.Array:
					JArray arr = (JArray)root;
					foreach (var item in arr)
					{
						count += RecursiveCount(item, ignoreKey);
					}
					break;
				case JTokenType.Integer:
					return root.ToObject<int>();
			}
			

			return count;
		}
	}
}
