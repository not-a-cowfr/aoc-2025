#!/usr/bin/env nu

let combinations = open ($env.CURRENT_FILE | path dirname | path dirname | path dirname | path join combination.txt) | str replace -a "L" "-" | str replace -a "R" "" | lines | par-each --keep-order {into int};

let foldf = {|it: string, acc: record<count: int, pos: int>| 
  let new_pos_raw = $it + $acc.pos
  let new_pos = $new_pos_raw mod 100

  let zeros: int = if $new_pos_raw < 0 {
    ($new_pos_raw | math abs) // 100 + ($acc.pos != 0 | into int)
  } else {
    $new_pos_raw // 100 + ($new_pos_raw == 0 | into int)
  }

  {count: ($acc.count + $zeros), pos: $new_pos}
}

$combinations | reduce --fold {count: 0, pos: 50} $foldf
