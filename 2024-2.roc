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
    |> List.map |lst|
        List.walk
            List.range({ start: At 0, end: Before (List.len(lst) - 1) })
            []
            |acc, idx|
                when Result.map2 (List.get lst idx) (List.get lst (idx + 1)) |a, b| a - b is
                    Ok v -> List.append acc v
                    _ -> acc
        |> |l| (List.any l |x| (Num.abs x < 1) or (Num.abs x > 3), List.all l Num.is_negative, List.all l Num.is_positive)
    |> List.map |(outside_range, all_neg, all_pos)| !outside_range and (all_neg or all_pos)
    |> List.count_if |x| x

expect example |> parse |> part1 == 2

trend : List I64 -> (Num a -> Bool)
trend = |lst|
    # Result.map2 (List.get lst 0) (List.get lst ((List.len lst) - 1)) |a, b| if a >= b then Num.is_positive else Num.is_negative
    # |> Result.with_default (if List.sum lst >= 0 then Num.is_negative else Num.is_positive)
    (if List.sum lst >= 0 then Num.is_negative else Num.is_positive)
    # (if List.sum lst >= (Num.to_i64(List.len lst) + 1) then Num.is_negative else Num.is_positive)
# |> Result.with_default \_ -> Bool.true

part2 = |lsts|
    lsts
    |> List.map |lst|
        List.walk
            List.range({ start: At 0, end: Before (List.len(lst) - 1) })
            []
            |acc, idx|
                when Result.map2 (List.get lst idx) (List.get lst (idx + 1)) |a, b| a - b is
                    Ok v -> List.append acc v
                    _ -> acc
        |> |l|
            when List.find_first_index l |n| (trend l)(n) or (Num.abs n < 1) or (Num.abs n > 3) is
                Ok i if i == (List.len l - 1) -> (List.drop_last l 1, l)
                Ok i ->
                    dbg (lst, i)
                    Result.map2(List.get l i, List.get l (i + 1), |a, b| a + b)
                    |> Result.map_ok |new| ( List.drop_at l (i + 1) |> List.set i new, l)
                    |> Result.with_default (l, l)

                _ -> (l, l)
        # |> |(l, _)| (List.any l |n| (Num.abs n < 1) or (Num.abs n > 3), List.all l Num.is_positive, List.all l Num.is_negative)
        |> |(l, _)| (List.any l |n| (Num.abs n < 1) or (Num.abs n > 3), List.all l Num.is_positive, List.all l Num.is_negative)
    # |> List.count_if |x| !x
    |> List.count_if |(outside_range, all_pos, all_neg)| !outside_range and (all_pos or all_neg)

expect example |> parse |> part2 == 4

main! = |_args|
    parsed = parse input
    p1 = part1 parsed
    p2 = part2 parsed

    Stdout.write! "${Inspect.to_str p1}\n${Inspect.to_str p2}"
