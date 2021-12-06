import { readFileSync } from "fs"

let rawInput: string[] = readFileSync("../input/05").toString().trim().split("\n")

class Coordinate {
  constructor(public x: number, public y: number) {}
  toString() {
    return `${this.x},${this.y}`
  }
}
type direction = "horizontal" | "vertical" | "slanted"
type ventLine = {
  direction: direction
  from: Coordinate
  to: Coordinate
  coordinates: Coordinate[]
}

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
    return { direction: "slanted", from: left, to: right, coordinates: [] }
  }
})

console.log("horizontal", ventLines.filter(({ direction }) => direction === "horizontal").length)
console.log("vertical", ventLines.filter(({ direction }) => direction === "vertical").length)
console.log("slanted", ventLines.filter(({ direction }) => direction === "slanted").length)

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
    case "slanted":
      break
  }
})

let coordinateHistogram = ventLines.reduce((acc: Map<string, number>, { coordinates }) => {
  coordinates.forEach((c) => acc.set(c.toString(), (acc.get(c.toString()) || 0) + 1))
  return acc
}, new Map())

let dangerousCoordinates: string[] = []
coordinateHistogram.forEach((val, key) => {
  if (val > 1) dangerousCoordinates.push(key)
})

console.log("part1", dangerousCoordinates.length)
