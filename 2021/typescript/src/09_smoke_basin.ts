import { readFileSync } from "fs"
type point = number
type grid = point[][]

// Parse input into a 2d grid of numbers, encoding their X and Y position and value N
// as a single number YY0XX00N (N is %10, X is %1000 / 1000 and Y is / 1000_000)
// I do this because a single literal number is convenient when using a Set.
let grid: grid = readFileSync("../input/09")
  .toString()
  .trim()
  .split("\n")
  .map((line: string, y: number) =>
    line.split("").map((n: string, x: number) => y * 1000 * 1000 + x * 1000 + parseInt(n))
  )

// Getters for the encoded X, Y and N
const x = (point: point) => Math.floor((point % 1000000) / 1000)
const y = (point: point) => Math.floor(point / 1000000)
const n = (point: point) => point % 10

function adjacent(grid: grid, x: number, y: number): point[] {
  let above = grid[y - 1]
  let below = grid[y + 1]

  return [above && above[x], grid[y][x - 1], grid[y][x + 1], below && below[x]].filter(
    (point) => point !== undefined
  )
}

let minima: point[] = []

for (let y = 0; y < grid.length; y++) {
  for (let x = 0; x < grid[y].length; x++) {
    let near = adjacent(grid, x, y)

    if (near.every((point) => n(point) > n(grid[y][x]))) {
      minima.push(grid[y][x])
    }
  }
}

console.log(
  "part 1",
  minima.reduce((sum, point) => sum + n(point) + 1, 0)
)

function basin(point: number, grid: grid, set: Set<point>): Set<point> {
  set.add(point)

  let near = adjacent(grid, x(point), y(point)).filter((point) => n(point) < 9 && !set.has(point))

  near.forEach((point) => basin(point, grid, set))
  return set
}

let part2 = minima
  .map((point) => basin(point, grid, new Set()).size)
  .sort((a, b) => b - a)
  .slice(0, 3)
  .reduce((product, size) => product * size)
console.log("part 2", part2)
