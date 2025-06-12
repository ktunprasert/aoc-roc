app [main!] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br" }

import pf.Stdout

example = "3   4\n4   3\n2   5\n1   3\n3   9\n3   3\n"

parse = |s|
    s
    |> Str.split_on("\n")
    |> List.map
        |v|
            v
            |> Str.split_on "   "
            |> List.map |x| Str.to_u64(x) ?? 0
    |> List.drop_last 1
    |> List.walk
        ([], [])
        |(left, right), v|
            when v is
                [a, b] -> (List.append left a, List.append right b)
                _ -> (left, right)
# |> dbg

main! = |_|
    # _ : List (List _)
    total =
        parse example
        |> |(l, r)| (List.sort_asc l, List.sort_asc r)
        |> |(l, r)| List.map2 l r Num.abs_diff
        |> List.sum
        # |> dbg

    Stdout.write! "${Inspect.to_str total}"
