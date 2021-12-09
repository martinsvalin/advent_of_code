import { readFileSync } from "fs"
let crabs: number[] = readFileSync("../input/07")
  .toString()
  .trim()
  .split(",")
  .map((n: string) => parseInt(n))
  .sort((a: number, b: number) => a - b)

// I've got crabs at position 0, but otherwise we'd have to normalize them like
// crabs.map((n) => n - crabs[0])

type Zipper = {
  left: number[]
  right: number[]
  sumLeft: number
  sumRight: number
}
type costFunction = { (n: number, position: number): number }

// Part 1, crabs move 1 position at the cost of 1 unit of fuel
let partOneCostFunction: costFunction = (n: number, position: number) => Math.abs(n - position)

// Strategy is to move across all the positions and move crabs at those positions
// over from our right-side list to our left-side list, while updating the sum
// fuel cost of all crabs to our left (increasing) and to our right (decreasing)
function calculateCostsForAllPositions(cost: costFunction): number[] {
  let position = 0
  let sums: number[] = []
  let zipper: Zipper = {
    left: [],
    right: [...crabs],
    sumLeft: 0,
    sumRight: crabs.reduce((sum, n) => sum + cost(n, position), 0),
  }

  while (zipper.right.length) {
    // move over crabs at this position to the left
    while (zipper.right[0] === position) {
      let mover = zipper.right.shift()
      if (mover !== undefined) {
        zipper.left.unshift(mover)
      }
    }

    // Update the sum
    zipper.sumLeft = zipper.left.reduce((sum, n) => sum + cost(n, position), 0)
    zipper.sumRight = zipper.right.reduce((sum, n) => sum + cost(n, position), 0)

    sums.push(zipper.sumLeft + zipper.sumRight)

    position++
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
