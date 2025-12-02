#!/usr/bin/env nu

let id_ranges = ^cat ($env.CURRENT_FILE | path dirname | path dirname | path dirname | path join ids.txt) | split row ",";
mut fake_ids: list<int> = [];

for id in ($id_ranges | parse --regex "(?<start>\\d+)-(?<end>\\d+)" | into int start | into int end) {
	for n in $id.start..$id.end {
		let n_str = $n | into string;
		let len = $n_str | str length;
		if ($len mod 2 == 1) { continue } # skip odd length numbers because they cant match the pattern
		let halfway = $len / 2 | into int;

		# split the string into 2 halves
		let first_half = $n_str | str substring 0..<$halfway; # exclusive spread so it doesnt get a character that should be in the second half
		let second_half = $n_str | str substring $halfway..;

		# print $"($first_half) and ($second_half)"

		if ($first_half == $second_half) {
			# print $n
			$fake_ids = $fake_ids | append $n;
		}
	}
}

$fake_ids | math sum
