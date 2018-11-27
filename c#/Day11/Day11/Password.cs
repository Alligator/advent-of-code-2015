using System;
using System.Collections.Generic;
using System.Text;
using System.Linq;
using System.Text.RegularExpressions;

namespace Day11
{
	public class Password
	{
		public string Value { get; set; }

		public Password(string value)
		{
			this.Value = value;
		}

		public void Increment()
		{
			StringBuilder sb = new StringBuilder(Value);
			for (int i = sb.Length - 1; i >= 0; i--)
			{
				char current = sb[i];
				if (current == 'z')
				{
					sb[i] = 'a';
				}
				else
				{
					sb[i]++;
					break;
				}
			}
			Value = sb.ToString();
		}

		public bool IsValid()
		{
			bool hasStraight = Value
				.Select((item, index) => new Tuple<char, char, char>(
					index == 0 ? default(char) : Value[index - 1],
					item,
					index == Value.Length - 1 ? default(char) : Value[index + 1]
				))
				.Any(value =>
					value.Item1 == value.Item2 - 1
					&& value.Item2 == value.Item3 - 1
				);
			if (!hasStraight)
			{
				return false;
			}

			bool hasBlacklisted = Regex.IsMatch(Value, @"[iol]");
			if (hasBlacklisted)
			{
				return false;
			}

			bool hasPairs = Regex.IsMatch(Value, @"(?:([a-z])\1).*(?:((?!\1)[a-z])\2)");
			if (!hasPairs)
			{
				return false;
			}

			return true;
		}
	}
}
