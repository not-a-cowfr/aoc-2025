#!/usr/bin/env nu

let combination_raw = ^cat ($env.CURRENT_FILE | path dirname | path dirname | path join combination.txt) | lines;
mut pos = 50;
mut zero_count = 0;

def occurances [thing: any]: list<any> -> any {
    $in | each {|n| $n mod 100} | where $it == $thing | length
}

for l in $combination_raw {
    let data = $l
        | parse --regex "(?<direction>[LR])(?<amount>\\d+)"
        | into int amount
        | get 0;

    mut new_pos = $pos;

    if $data.direction == "R" {
        $new_pos += $data.amount;
    } else {
        $new_pos -= $data.amount;
    }

    # this looks so stupid but thers no better way to expand a range into a list then get the occurances of something
    $zero_count += $new_pos..(if $data.direction == "R" {$pos + 1} else {$pos - 1}) | par-each {|n| $n mod 100} | where $it == 0 | length;

    $new_pos = $new_pos mod 100;
            
    $pos = $new_pos;

	print -n $"\rturning ($data.direction) ($data.amount) times to end up at ($pos), zero count is now ($zero_count) "
};

print "\ntimes hit 0:"
$zero_count
