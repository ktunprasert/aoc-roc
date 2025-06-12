app [main!] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br" }

import pf.Stdout

# import "2024-2.txt" as day1 : Str
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
        List.walk_until
            List.range({ start: At 0, end: Before (List.len(lst) - 1)})
            []
            |acc, idx|
                when Result.map2 (List.get lst idx) (List.get lst (idx+1)) |a, b| a - b is
                  Ok v ->  List.append acc v |> Continue
                  _ -> Break acc
        # |> List.any |x| (x < 1) || (x > 3)
    |> dbg



main! = |_args|
    _ = example |> parse |> part1
    Stdout.write! "ok"


# part1 = |x|
#     x
#     |> |(l, r)| (List.sort_asc l, List.sort_asc r)
#     |> |(l, r)| List.map2 l r Num.abs_diff
#     |> List.sum

# expect example |> parse |> part1 == 11

# alter : Result U64 _ -> Result U64 _
# alter = |value| value ?? 0 |> Num.add 1 |> Ok

# part2 = |x|
#     x
#     |> |(l, r)|
#         (
#             l,
#             List.walk(
#                 r,
#                 Dict.empty {},
#                 |acc, elem|
#                     Dict.update(acc, elem, alter),
#             ),
#         )
#     |> |(nums, dict)|
#         List.walk(
#             nums,
#             0,
#             |acc, n|
#                 v = Dict.get(dict, n) ?? 0
#                 acc + n * v,
#         )

# expect example |> parse |> part2 == 31

# main! = |_|
#     parsed = parse day1

#     p1 = part1 parsed
#     p2 = part2 parsed

#     Stdout.line! "${Inspect.to_str p1}\n${Inspect.to_str p2}"
