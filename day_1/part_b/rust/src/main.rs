use std::ops::RangeInclusive;
use std::path::PathBuf;
use std::{env, fs};

fn main() -> Result<(), Box<dyn std::error::Error>> {
	let root = PathBuf::from(env::var("CARGO_MANIFEST_DIR")?);
	let combination_file = root
		.parent()
		.unwrap()
		.parent()
		.unwrap()
		.join("combination.txt");
	let combination = fs::read_to_string(combination_file)?;
	let combination_lines = combination.lines();

	let mut pos = 50;
	let mut zero_count = 0;

	for line in combination_lines {
		let (direction, amount) = split_first_char(line);
		let amount = amount.parse::<i32>()?;

		let mut new_pos = pos;

		match direction {
			| 'R' => new_pos += amount,
			| 'L' => new_pos -= amount,
			| _ => unreachable!(),
		}

		zero_count += range(new_pos, if direction == 'R' { pos + 1 } else { pos - 1 })
			.map(|n| n.rem_euclid(100))
			.filter(|&x| x == 0)
			.collect::<Vec<i32>>()
			.len();

		pos = new_pos.rem_euclid(100);
	}

	println!("times hit 0: {}", zero_count);

	Ok(())
}

fn split_first_char(s: &str) -> (char, &str) {
	let mut chars = s.chars();
	match chars.next() {
		| Some(first_char) => (first_char, chars.as_str()),
		| None => unreachable!(),
	}
}

// need to do this because some ranges try to generate backwards which rust doesnt do resulting in an empty array
fn range(
	start: i32,
	end: i32,
) -> RangeInclusive<i32> {
	if start <= end {
		start..=end
	} else {
		end..=start
	}
}
