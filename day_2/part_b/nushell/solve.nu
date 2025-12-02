#!/usr/bin/env nu

let id_ranges = ^cat ($env.CURRENT_FILE | path dirname | path dirname | path dirname | path join ids.txt) | split row ",";
mut fake_ids: list<int> = [];

for id in ($id_ranges | parse --regex "(?<start>\\d+)-(?<end>\\d+)" | into int start | into int end) {
	for n in $id.start..$id.end {
		let n_str = $n | into string;
		let len = $n_str | str length;
		# if ($len == 1) { continue }; # maybe things like 1 or 8 arent counted
		let halfway = $len / 2 | into int;

		# only need to go to halfway because you cant have something larger than half the string thats there twice
		# unless counting like overlap but i dont think the puzzle wants that
		for i in 0..$halfway {
			let first_part = $n_str | str substring 0..<$i; # exclusive spread

			# replaces the full string with the testing part, if everything gets replaced then the entire string was just that part repeated
			if ($n_str | str replace -a $first_part "" | is-empty) {
				# print $"haha worked for ($n_str)"
				$fake_ids = $fake_ids | append $n;
			}
		}
	}
}

$fake_ids | uniq | math sum
