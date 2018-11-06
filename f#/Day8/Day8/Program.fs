// Learn more about F# at http://fsharp.org

open Counter
open System.IO
open System

[<EntryPoint>]
let main argv =
    let result =
        File.ReadAllLines @"C:\Users\alligator\dev\aoc2015\8.txt"
        |> Seq.filter (fun x -> not (String.IsNullOrEmpty x))
        |> Seq.map count
        |> Seq.reduce (fun acc v -> {
            Code = acc.Code + v.Code;
            Characters = acc.Characters + v.Characters
            ReplacedCharacters = acc.ReplacedCharacters + v.ReplacedCharacters
        })
    printfn "Part 1: %i\nPart 2: %i" (result.Code - result.Characters) (result.ReplacedCharacters - result.Code)
    0 // return an integer exit code
