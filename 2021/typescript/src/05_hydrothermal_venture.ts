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
  } else if (left.y === right.y) {
    return { direction: "vertical", from: left, to: right, coordinates: [] }
  } else {
    return { direction: "diagonal", from: left, to: right, coordinates: [] }
  }
})

// Fill in each coordinate a line passes through
function fillCoordinates(ventLine: ventLine): void {
  let [x, y] = [ventLine.from.x, ventLine.from.y]

  // Determine the direction to move x and y, to go from `from` to `to`.
  // We'll use this to step closer when iterating.
  // Apologies for the nested ternary ;) but step is zero for some directions
  let dx = ventLine.from.x === ventLine.to.x ? 0 : ventLine.from.x < ventLine.to.x ? 1 : -1
  let dy = ventLine.from.y === ventLine.to.y ? 0 : ventLine.from.y < ventLine.to.y ? 1 : -1

  // Don't forget the first coordinate
  ventLine.coordinates.push(ventLine.from)

  // To support horizontal, vertical and diagonal stepping,
  // iterate until both x and y are at the destination coordinate
  while (x !== ventLine.to.x || y !== ventLine.to.y) {
    x = x + dx
    y = y + dy
    ventLine.coordinates.push(new Coordinate(x, y))
  }
}

// Fill coordinates for horizontal and vertical lines, ignore diagonal for now
ventLines
  .filter(({ direction }) => ["horizontal", "vertical"].includes(direction))
  .forEach(fillCoordinates)

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

// Now it's time to set the coordinates where diagonal vent lines pass through.
ventLines.filter(({ direction }) => direction === "diagonal").forEach(fillCoordinates)

// Collect the dangerous coordinates again, i.e. the ones with more than one vent line
// Since the histogram is created for all lines (vertical, horizontal and diagonal),
// we need to clear the dangerous coordinates we had before, or they'll be double-counted
dangerousCoordinates = []
createHistogram(ventLines).forEach((val, key) => {
  if (val > 1) dangerousCoordinates.push(key)
})
console.log("part2", dangerousCoordinates.length)
