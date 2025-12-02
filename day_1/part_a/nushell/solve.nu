#!/usr/bin/env nu

let combinations = open ($env.CURRENT_FILE | path dirname | path dirname | path dirname | path join combination.txt) | str replace -a "L" "-" | str replace -a "R" "" | lines | par-each --keep-order {into int};

let foldf = {|it: string, acc: record<count: int, pos: int>| 
  let new: int = ($it + $acc.pos) mod 100
  {count: ($acc.count + ($new == 0 | into int)), pos: $new}
}

$combinations | reduce --fold {count: 0, pos: 50} $foldf
