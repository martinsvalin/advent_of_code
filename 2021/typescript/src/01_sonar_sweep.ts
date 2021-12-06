import { readFileSync } from "fs"

let input = readFileSync("../input/01")
  .toString()
  .trim()
  .split("\n")
  .map((n) => parseInt(n))

// Example:
// > sliding_window([1,2,3,4,5,6], 3)
// [[1,2,3], [2,3,4], [3,4,5], [4,5,6]]
function sliding_window(list: any[], size: number): any[][] {
  let result = []
  for (var i = 0; i <= list.length - size; i++) {
    result.push(list.slice(i, i + size))
  }
  return result
}

function count_increases(list: number[]): number {
  return sliding_window(list, 2).filter(([left, right]) => left < right).length
}

// First problem:
// Count how many times the depth increases between two consecutive measurements?

console.log("part 1", count_increases(input))

// Second problem:
// Consider groups of three. Sum these groups. How many times does depth increase then?

function sum(list: number[]): number {
  return list.reduce((a, b) => a + b)
}

let groups = sliding_window(input, 3).map(sum)
console.log("part 2", count_increases(groups))
