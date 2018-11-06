module Counter

open System.Text.RegularExpressions

type CountResult = { Code: int; Characters: int; ReplacedCharacters: int }

// wrapper for Regex.Replace so it can partially applied
let regexReplace (pattern:string) (replacement:string) (str:string):string =
    Regex.Replace(str, pattern, replacement)

let count (str:string):CountResult =
    let subbedStr =
        str
        |> regexReplace "\\\\x[0-9a-f][0-9a-f]" "1"
        |> regexReplace "\\\\\"" "1"
        |> regexReplace "\\\\\\\\" "1"
    let replacedStr =
        str
        |> regexReplace "\"" "\\\""
        |> regexReplace "\\\\" "\\\\"
    { Code = str.Length; Characters = subbedStr.Length - 2; ReplacedCharacters = replacedStr.Length }