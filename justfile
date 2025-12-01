set shell := ["nu", "-c"]

[private]
@default:
  just --choose

[no-cd]
@run:
	let day = ls | where type == dir | where name =~ "day_.+" | get name | str join "\n" | fzf; \
	let part = ls -s $day | where type == dir | where name =~ "part_.+" | get name | str join "\n" | fzf; \
	let lang = ls -s $"($day)/($part)" | where type == dir | get name | str join "\n" | fzf; \
	match $lang { \
		'rust' => {cargo run -q $"($day)-($part)"}, \
		'nushell' => {nu -c $'./($day)/($part)/nushell/solve.nu'}, \
		'javascript' => {bun run $'./($day)/($part)/javascript/solve.ts'}, \
	} 
