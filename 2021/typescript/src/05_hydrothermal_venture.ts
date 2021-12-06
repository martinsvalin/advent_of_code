import { readFileSync } from "fs"

let rawInput: string[] = readFileSync("../input/05").toString().trim().split("\n")

class Coordinate {
  constructor(public x: number, public y: number) {}
  toString() {
    return `${this.x},${this.y}`
  }
}
type direction = "horizontal" | "vertical" | "diagonal"
type ventLine = {
  direction: direction
  from: Coordinate
  to: Coordinate
  coordinates: Coordinate[]
}

// Parse input into vent lines, with a direction, from and to coordinates
// and an empty set of the full coordinates the line passes through
// which will be filled in shortly.
let ventLines: ventLine[] = rawInput.map((line) => {
  let [[x1, y1], [x2, y2]] = line
    .split(" -> ", 2)
    .map((coord) => coord.split(",").map((n) => parseInt(n)))
  let left = new Coordinate(x1, y1)
  let right = new Coordinate(x2, y2)
  if (left.x === right.x && left.y >= right.y) {
    return { direction: "horizontal", from: right, to: left, coordinates: [] }
  } else if (left.x === right.x && left.y < right.y) {
    return { direction: "horizontal", from: left, to: right, coordinates: [] }
  } else if (left.x >= right.x && left.y === right.y) {
    return { direction: "vertical", from: right, to: left, coordinates: [] }
  } else if (left.x < right.x && left.y === right.y) {
    return { direction: "vertical", from: left, to: right, coordinates: [] }
  } else {
    return { direction: "diagonal", from: left, to: right, coordinates: [] }
  }
})

// Fill in each coordinate a line passes through, ignoring diagonal lines.
ventLines.forEach((ventLine) => {
  switch (ventLine.direction) {
    case "vertical":
      for (let x = ventLine.from.x; x <= ventLine.to.x; x++) {
        ventLine.coordinates.push(new Coordinate(x, ventLine.from.y))
      }
      break
    case "horizontal":
      for (let y = ventLine.from.y; y <= ventLine.to.y; y++) {
        ventLine.coordinates.push(new Coordinate(ventLine.from.x, y))
      }
      break
    case "diagonal":
      break
  }
})

// With each vent line's full set of coordinates, we can now create a histogram
// counting the vent lines that pass through each coordinate.
// For comparable keys, we use the string representation of Coordinate as key
function createHistogram(ventLines: ventLine[]): Map<string, number> {
  return ventLines.reduce((acc, { coordinates }) => {
    coordinates.forEach((c) => acc.set(c.toString(), (acc.get(c.toString()) || 0) + 1))
    return acc
  }, new Map<string, number>())
}

// Collect the dangerous coordinates, i.e. the ones with more than one vent line
let dangerousCoordinates: string[] = []
createHistogram(ventLines).forEach((val, key) => {
  if (val > 1) dangerousCoordinates.push(key)
})

console.log("part1", dangerousCoordinates.length)

const increment = (n: number) => n + 1
const decrement = (n: number) => n - 1

// Now it's time to set the coordinates where diagonal vent lines pass through.
ventLines
  .filter(({ direction }) => direction === "diagonal")
  .forEach((ventLine) => {
    // Determine the direction to move x and y, to go from `from` to `to`.
    // We'll use this to step closer when iterating.
    let horizontalMove = ventLine.from.x < ventLine.to.x ? increment : decrement
    let verticalMove = ventLine.from.y < ventLine.to.y ? increment : decrement
    let [x, y] = [ventLine.from.x, ventLine.from.y]

    ventLine.coordinates.push(ventLine.from)

    // Since diagonal lines are always 45°, it doesn't matter stop at the final x or y.
    // We'll reach both at the same time.
    while (x != ventLine.to.x) {
      x = horizontalMove(x)
      y = verticalMove(y)
      ventLine.coordinates.push(new Coordinate(x, y))
    }
  })

// Collect the dangerous coordinates again, i.e. the ones with more than one vent line
// Since the histogram is created for all lines (vertical, horizontal and diagonal),
// we need to clear the dangerous coordinates we had before, or they'll be double-counted
dangerousCoordinates = []
createHistogram(ventLines).forEach((val, key) => {
  if (val > 1) dangerousCoordinates.push(key)
})
console.log("part2", dangerousCoordinates.length)
