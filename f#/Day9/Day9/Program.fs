open System
open System.IO

type Node = string
type Edge = {
    From: Node;
    To: Node;
    Distance: int;
}

type Graph = {
    Nodes: List<Node>;
    Edges: List<Edge>
}

let getEdge graph node1 node2 =
    graph.Edges
    |> Seq.filter (fun x -> x.From = node1 && x.To = node2)
    |> Seq.head

let parseFile fileName =
    let edges =
        File.ReadAllLines fileName
        |> Seq.map (fun x -> x.Split())
        |> Seq.map (fun x -> { From = x.[0]; To = x.[2]; Distance = Int32.Parse(x.[4]) })

    let mirroredEdges =
        edges
        |> Seq.map (fun x -> { From = x.To; To = x.From; Distance = x.Distance })

    let allEdges = Seq.append edges mirroredEdges
    let nodes = allEdges |> Seq.map (fun x -> x.From) |> Seq.distinct
    {
        Edges = allEdges |> Seq.toList;
        Nodes = nodes  |> Seq.toList;
    }
    
// taken from https://stackoverflow.com/a/286821
// return a lazy seq of all the permutations of list
let rec permutations list taken =
    seq {
        if Set.count taken = Seq.length list then yield []
        else
            for l in list do
                if not (Set.contains l taken) then
                    for perm in permutations list (Set.add l taken) do
                        yield l::perm
    }

let rec _getDistance (graph:Graph) tour distance =
    match tour with
    | [a;b] -> (getEdge graph a b).Distance + distance
    | a::b::tail -> _getDistance graph (b::tail) ((getEdge graph a b).Distance + distance)
    | _ -> 0

let getDistance graph tour =
    _getDistance graph tour 0

[<EntryPoint>]
let main argv =
    let graph = parseFile @"C:\Users\alligator\dev\aoc2015\9.txt"
    let perms = permutations graph.Nodes Set.empty
    let distances = perms |> Seq.map (getDistance graph)
    Console.WriteLine (Seq.min distances)
    Console.WriteLine (Seq.max distances)
    0 // return an integer exit code