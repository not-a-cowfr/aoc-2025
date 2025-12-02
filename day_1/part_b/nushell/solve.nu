#!/usr/bin/env nu

let combination_raw = ^cat ($env.CURRENT_FILE | path dirname | path dirname | path dirname | path join combination.txt) | lines;
mut pos = 50;
mut zero_count = 0;

for l in $combination_raw {
    let data = $l
        | parse --regex "(?<direction>[LR])(?<amount>\\d+)"
        | into int amount
        | get 0;

    # make clone so that we ahve something to mutate but still keep the starting position for later
    mut new_pos = $pos;

    # if turning right, add the amount, else subtract it
    if $data.direction == "R" {
        $new_pos += $data.amount;
    } else {
        $new_pos -= $data.amount;
    }

    # this looks so stupid but thers no better way to expand a range into a list then get the occurances of something
    $zero_count += $new_pos..(if $data.direction == "R" {$pos + 1} else {$pos - 1}) # makes range from the starting position to the new position, not accounting for looping
        | par-each {|n| $n mod 100} # account for looping now
        | where $it == 0 # only the times that it moved onto 0
        | length; # get the length of the list which is just th total of times it was on 0

# let a = $new_pos..(if $data.direction == "R" {$pos + 1} else {$pos - 1}) | par-each {||};
# let b = $new_pos..(if $data.direction == "R" {$pos + 1} else {$pos - 1}) | par-each {|n| $n mod 100} | where $it == 0;

    # now we can update the stored position
    $pos = $new_pos mod 100;

	# print $"turning ($data.direction) ($data.amount) times to end up at ($pos), zero count is now ($a) "
	# print $"($a)\t\t\t($b)\n\n"
};

print "\ntimes hit 0:"
$zero_count
