import { readFileSync } from "fs"

// let rawInput = "00100 11110 10110 10111 10101 01111 00111 11100 10000 11001 00010 01010".split(" ")

let rawInput: string[] = readFileSync("../input/03").toString().trim().split("\n")

const HIGHBIT = 2 ** (rawInput[0].length - 1)

let input = rawInput.map((string) => parseInt(string, 2))

let bits: number[] = []
for (let bit = HIGHBIT; bit > 0; bit = bit >> 1) {
  bits.push(bit)
}

let gamma = bits
  .map((bit) => (input.reduce((sum, n) => (n & bit ? sum + 1 : sum), 0) > input.length / 2 ? 1 : 0))
  .join("")
let epsilon = bits
  .map((bit) => (input.reduce((sum, n) => (n & bit ? sum + 1 : sum), 0) < input.length / 2 ? 1 : 0))
  .join("")

console.log("gamma", parseInt(gamma, 2))
console.log("epsilon", parseInt(epsilon, 2))
console.log("part1", parseInt(gamma, 2) * parseInt(epsilon, 2))

const countNumbersWithBitSet = (numbers: number[], bit: number) =>
  numbers.reduce((sum, n) => (n & bit ? sum + 1 : sum), 0)

function filterByCriteria(
  numbers: number[],
  bit: number,
  criteria: (bitIsMostlySet: boolean, bit: number) => number
): number {
  let bitByCriteria = criteria(countNumbersWithBitSet(numbers, bit) >= numbers.length / 2, bit)
  let filtered = numbers.filter((n) => (n & bit) === bitByCriteria)

  if (filtered.length === 1) {
    return filtered[0]
  } else {
    return filterByCriteria(filtered, bit >> 1, criteria)
  }
}

function oxygen(input: number[], bit: number = HIGHBIT): number {
  const criteria = (bitIsMostlySet: boolean, bit: number) => (bitIsMostlySet ? bit : 0)
  return filterByCriteria(input, bit, criteria)
}
function carbon(input: number[], bit: number = HIGHBIT): number {
  const criteria = (bitIsMostlySet: boolean, bit: number) => (bitIsMostlySet ? 0 : bit)
  return filterByCriteria(input, bit, criteria)
}

console.log("oxygen", oxygen(input))
console.log("carbon", carbon(input))
console.log("part2", oxygen(input) * carbon(input))
