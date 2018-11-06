module Tests

open System
open Counter
open Xunit

[<Theory>]
[<InlineData("\"\"",                2,  0,  6)>]
[<InlineData("\"\\\\\"",            4,  1,  10)>]
[<InlineData("\"abc\"",             5,  3,  9)>]
[<InlineData("\"aaa\\\"aaa\"",      10, 7,  17)>]
[<InlineData("\"\\x2f\"",           6,  1,  11)>]
[<InlineData("\"abc\\\"def\\x2f\"", 14, 8,  22)>]
[<InlineData("\"a\\\"a\\\"\"",      8,  4,  18)>]
let ``Count`` str code characters replacedCharacters =
    let result = count str
    Assert.Equal(code, result.Code)
    Assert.Equal(characters, result.Characters)
    Assert.Equal(replacedCharacters, result.ReplacedCharacters)