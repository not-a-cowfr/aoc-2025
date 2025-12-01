#!/usr/bin/env nu

let combination_raw = ^cat ($env.CURRENT_FILE | path dirname | path dirname | path join combination.txt) | lines;
mut pos = 50;
mut zero_count = 0;

for l in $combination_raw {
    let data = $l
        | parse --regex "(?<direction>[LR])(?<amount>\\d+)"
        | into int amount
        | get 0;

    if $data.direction == "R" {
        $pos += $data.amount;
    } else {
        $pos -= $data.amount;
    }

	$pos = $pos mod 100;
	
	if $pos == 0 {
		$zero_count += 1;
	}

	# for debugging
	print -n $"\rturning ($data.direction) ($data.amount) times to end up at ($pos) "
};

print "\ntimes hit 0:"
$zero_count
