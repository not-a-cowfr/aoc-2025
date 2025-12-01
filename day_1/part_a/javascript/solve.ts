import path from 'path';

const combination_file = path.resolve(import.meta.dir, '../../combination.txt');
const combination = (await Bun.file(combination_file).text()).split(/\r?\n/);

let pos = 50;
let zeroCount = 0;

function splitString(inputString: string): [string, string] {
	if (inputString.length === 0) {
		return ['', ''];
	}

	return [inputString.charAt(0), inputString.slice(1)];
}

function modulo(n: number, d: number): number {
	return ((n % d) + d) % d;
}

for (const line of combination) {
	const [direction, amount_str] = splitString(line);
	const amount = Number(amount_str);

	switch (direction) {
		case 'R':
			pos += amount;
			break;
		case 'L':
			pos -= amount;
			break;
		default:
			throw new Error('found something besides L or R in the direction part');
	}

	pos = modulo(pos, 100);

	if (pos == 0) {
		zeroCount += 1;
	}
}

console.log(`times hit 0: ${zeroCount}`);
