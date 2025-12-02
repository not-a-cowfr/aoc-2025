import path from 'path';

const combination_file = path.resolve(import.meta.dir, '../../combination.txt');
const combination = (await Bun.file(combination_file).text()).split(/\r?\n/);

let pos = 50;
let zeroCount = 0;

function splitString(inputString: string): [string, string] {
	if (inputString.length === 0) return ['', ''];

	return [inputString.charAt(0), inputString.slice(1)];
}

function modulo(n: number, d: number): number {
	return ((n % d) + d) % d;
}

function range(start: number, end: number): number[] {
	const [s, e] = start <= end ? [start, end] : [end, start];

	const length = e - s + 1;
	return Array.from({ length }, (_, i) => s + i);
}

for (const line of combination) {
	const [direction, amount_str] = splitString(line);
	const amount = Number(amount_str);

	let new_pos = pos;
	new_pos = direction === 'R' ? new_pos + amount : new_pos - amount;

	zeroCount += range(new_pos, direction == 'R' ? pos + 1 : pos - 1)
		.map((n) => modulo(n, 100))
		.filter((item) => item === 0).length;

	pos = modulo(new_pos, 100);
}

console.log(`times hit 0: ${zeroCount}`);
