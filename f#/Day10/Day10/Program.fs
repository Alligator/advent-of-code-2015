// Learn more about F# at http://fsharp.org

open System

let partitionBy pred list =
    let rec partitionHelper acc list =
        match list with
        | e1::e2::rest when pred e1 e2 -> List.rev(e1::acc), e2::rest
        | e1::rest -> partitionHelper (e1::acc) rest
        | [] -> List.rev(acc), []
    partitionHelper [] list

let partitionAllBy pred list =
    let rec helper acc list =
        match partitionBy pred list with
        | l, [] -> l::acc |> List.rev
        | l, rest -> helper (l::acc) rest
    helper [] list

let getNext input =
    partitionAllBy (<>) [for c in input -> c]
    |> Seq.map (fun x -> sprintf "%i%c" x.Length x.[0])
    |> String.concat ""

[<EntryPoint>]
let main argv =
    let result =
       seq { 0 .. 49 }
       |> Seq.fold (fun acc i -> getNext acc) "1113122113"
       |> Seq.length
    printf "%i" result
    0 // return an integer exit code
