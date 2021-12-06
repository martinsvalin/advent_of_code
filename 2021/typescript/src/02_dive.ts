import { readFileSync } from "fs"

let rawInput: string[] = readFileSync("../input/02").toString().trim().split("\n")

type direction = "forward" | "down" | "up"

let input: { direction: direction; amount: number }[] = rawInput.map((line: string) => {
  let lineParts = line.split(" ", 2)
  let direction = lineParts[0] as direction
  let amount = parseInt(lineParts[1])
  return { direction, amount }
})

let part1 = input.reduce(
  (position, { direction, amount }) => {
    switch (direction) {
      case "forward":
        position.x += amount
        break
      case "down":
        position.y += amount
        break
      case "up":
        position.y -= amount
        break
    }
    return position
  },
  { x: 0, y: 0 }
)

console.log("part 1", part1.x * part1.y)

let part2 = input.reduce(
  (position, { direction, amount }) => {
    switch (direction) {
      case "forward":
        position.x += amount
        position.y += amount * position.aim
        return position
      case "down":
        position.aim += amount
        return position
      case "up":
        position.aim -= amount
        return position
    }
  },
  { x: 0, y: 0, aim: 0 }
)
console.log("part 2", part2.x * part2.y)
