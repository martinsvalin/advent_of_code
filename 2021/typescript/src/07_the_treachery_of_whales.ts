import { readFileSync } from "fs"
let crabs: number[] = readFileSync("../input/07")
  .toString()
  .trim()
  .split(",")
  .map((n: string) => parseInt(n))
  .sort((a: number, b: number) => a - b)

// I've got crabs at position 0, but otherwise we'd have to normalize them like
// crabs.map((n) => n - crabs[0])

type costFunction = { (n: number, position: number): number }

// Part 1, crabs move 1 position at the cost of 1 unit of fuel
let partOneCostFunction: costFunction = (n: number, position: number) => Math.abs(n - position)

// Apply the cost function for each crab at each position, building up a list of
// sums of fuel costs that we can find the minimum in.
function calculateCostsForAllPositions(cost: costFunction): number[] {
  let sums: number[] = []

  for (let position = 0; position < crabs.length; position++) {
    sums.push(crabs.reduce((sum, n) => sum + cost(n, position)))
  }

  return sums
}

console.log(
  "part 1",
  calculateCostsForAllPositions(partOneCostFunction).reduce((a, b) => Math.min(a, b))
)

// For part 2, I guess we better calculate the cost at each step.
// It's a geometric sum
const geometricSum = (n: number): number => (n / 2) * n + n / 2
const partTwoCostFunction = (n: number, position: number) => geometricSum(Math.abs(n - position))

console.log(
  "part 2",
  calculateCostsForAllPositions(partTwoCostFunction).reduce((a, b) => Math.min(a, b))
)
