using Microsoft.SqlServer.Server;
using System.Data.SqlTypes;

public static class Regex
{
  [SqlFunction]
  public static SqlBoolean RegexMatch(SqlChars input, SqlString pattern)
  {
    return System.Text.RegularExpressions.Regex.IsMatch(new string(input.Value), pattern.Value);
  }
}