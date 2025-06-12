app [main!] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br" }

import pf.Stdout

import "2024-2.txt" as input : Str
import "2024-2e.txt" as example : Str

parse = |s|
    s
    |> Str.split_on("\n")
    |> List.map
        |v|
            v
            |> Str.split_on " "
            |> List.map |x| Str.to_i64(x) ?? 0
    |> List.drop_last 1

part1 = |lsts|
    lsts
    |> List.map is_safe
    |> List.count_if |x| x

expect example |> parse |> part1 == 2

is_safe = |lst|
    diffs = List.walk
        List.range({ start: At 0, end: Before (List.len(lst) - 1) })
        []
        |acc, idx|
            when Result.map2 (List.get lst idx) (List.get lst (idx + 1)) |a, b| a - b is
                Ok v -> List.append acc v
                _ -> acc

    outside_range = List.any diffs |x| (Num.abs x < 1) or (Num.abs x > 3)
    all_neg = List.all diffs Num.is_negative
    all_pos = List.all diffs Num.is_positive

    !outside_range and (all_neg or all_pos)

part2 = |lsts|
    lsts
    |> List.map |lst|
        if is_safe lst then
            Bool.true
        else
            # Try removing each element one by one
            List.range({ start: At 0, end: Before (List.len lst) })
            |> List.any |i|
                List.drop_at lst i
                |> is_safe
    |> List.count_if |x| x

expect example |> parse |> part2 == 4

main! = |_args|
    parsed = parse input
    p1 = part1 parsed
    p2 = part2 parsed

    Stdout.write! "${Inspect.to_str p1}\n${Inspect.to_str p2}"
