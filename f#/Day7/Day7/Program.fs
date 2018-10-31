open System
open System.IO
open System.Text.RegularExpressions
open FSharp.Text.RegexProvider
open System.Collections.Generic

type ExprValue =
    | I of int
    | S of string

type OpCode =
    | And
    | Or
    | LShift
    | RShift
    | Not

type Expression = {
    LHS: ExprValue option;
    OpCode: OpCode option;
    RHS: ExprValue option;
    Variable: ExprValue;
}

type Bindings = Map<ExprValue, Expression>

let getOpCode (str:string):OpCode option =
    match str with
    | "AND"     -> Some(And)
    | "OR"      -> Some(Or)
    | "LSHIFT"  -> Some(LShift)
    | "RSHIFT"  -> Some(RShift)
    | "NOT"     -> Some(Not)
    | _         -> None

let getExprValue (str:string):ExprValue option =
    match (Int32.TryParse str) with
    | true, i  -> Some(I i)
    | false, _ -> if String.IsNullOrEmpty(str) then None else Some(S str)


type InstrRegex = Regex< @"^(?<lhs>[a-z]+|\d+)? ?(?<op>AND|OR|LSHIFT|RSHIFT|NOT)? ?(?<rhs>[a-z]+|\d+)? -> (?<var>[a-z]+)" >

let rec eval (var:ExprValue, bindings:Bindings):uint16 =
    // the business
    let rec doEval next var =
        match (bindings.TryFind var) with
        | Some(expr) ->
            match expr with
            | { LHS = Some(lhs); OpCode = Some(op); RHS = Some(rhs) } ->
                // two arg opcode
                match op with
                | And    -> next(lhs) &&& next(rhs)
                | Or     -> next(lhs) ||| next(rhs)
                | LShift -> next(lhs) <<< next(rhs)
                | RShift -> next(lhs) >>> next(rhs)
                | _ -> 0
            | { LHS = None; OpCode = Some(op); RHS = Some(rhs) } ->
                // single arg opcode, only not does this
                match op with
                | Not -> ~~~next(rhs)
                | _ -> 0
            | { LHS = Some(lhs) } ->
                // single value or variable
                match lhs with
                | I num -> num
                | S _ -> next(lhs)
            | _ -> 0
        | None ->
            match var with
            | I num -> num
            | S _ -> next(var)
       
    // memoization
    let cache = new Dictionary<ExprValue, int>()
    let rec memoDoEval v = h memoDoEval v
    and h memoDoEval v =
        match cache.TryGetValue(v) with
        | true, value -> value
        | _ ->
            let value = doEval memoDoEval v
            cache.Add(v, value)
            value

    // return value
    memoDoEval(var) &&& 0xFFFF |> Convert.ToUInt16

[<EntryPoint>]
let main argv =
    let lines:Bindings =
        File.ReadAllLines @"C:\Users\alligator\dev\aoc2015\7.txt"

        // Remove blank lines
        |> Seq.filter (fun x -> not (String.IsNullOrWhiteSpace(x)))

        // Regex atch each line
        |> Seq.map (fun x -> InstrRegex().TypedMatch(x))

        // Parse the line into an Expression type
        |> Seq.map (fun x-> {
            LHS = getExprValue x.lhs.Value;
            OpCode = getOpCode x.op.Value;
            RHS = getExprValue x.rhs.Value;
            Variable = getExprValue x.var.Value |> Option.get;
        })

        // Turn the seq into a seq of key/value pairs
        |> Seq.map(fun x -> x.Variable, x)

        // The the k/v pairs into a Map
        |> Map.ofSeq
    
    let part1 = eval(S "a", lines) |> Convert.ToInt32
    let part2 = eval(S "a", lines.Add(S "b", { LHS = Some(I part1); OpCode = None; RHS = None; Variable = S "b" }))
    printfn "part 1: %i\npart 2: %i" part1 part2
    0
