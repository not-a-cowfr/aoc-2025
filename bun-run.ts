import { $ } from 'bun';

const day = process.argv[2];
await $`bun run day_${day}/javascript/solve.ts`;
