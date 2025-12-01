use std::{
    env, fs,
    path::{Path, PathBuf},
};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let root = PathBuf::from(env::var("CARGO_MANIFEST_DIR")?);
    let combination_file = find_file_from_dir(root.parent().unwrap(), "combination.txt")?;
    let combination = fs::read_to_string(combination_file)?;
    let combination_lines = combination.lines();

    let mut pos = 50;
    let mut zero_count = 0;

    for line in combination_lines {
        let (direction, amount) = split_first_char(line);
        let amount = amount.parse::<i32>()?;

        match direction {
            'R' => pos += amount,
            'L' => pos -= amount,
            _ => unreachable!(),
        }

        // i think this is the same as the modulo operator
        pos = pos.rem_euclid(100);

        if pos == 0 {
            zero_count += 1;
        }
    }

    println!("times hit 0: {}", zero_count);

    Ok(())
}

fn find_file_from_dir(dir: &Path, filename: &str) -> Result<PathBuf, Box<dyn std::error::Error>> {
    let files = fs::read_dir(dir)?;

    for file in files {
        if let Ok(file) = file {
            let path = file.path();

            if let Some(filename_os_str) = path.file_name() {
                if let Some(filename_str) = filename_os_str.to_str() {
                    if filename_str == filename {
                        return Ok(path);
                    }
                }
            }
        }
    }

    Err("no files with that name found".into())
}

fn split_first_char(s: &str) -> (char, &str) {
    let mut chars = s.chars();
    match chars.next() {
        Some(first_char) => (first_char, chars.as_str()),
        None => unreachable!(),
    }
}
