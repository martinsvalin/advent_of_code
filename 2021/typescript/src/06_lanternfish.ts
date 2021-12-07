import { readFileSync } from "fs"

let rawInput: number[] = readFileSync("../input/06")
  .toString()
  .trim()
  .split(",")
  .map((n: string) => parseInt(n))

// fish is a list of 9 numbers, positions 0..6 for the fish that spawn, 7..8 for newborns
type fish = [number, number, number, number, number, number, number, number, number]
let fish: fish = [0, 0, 0, 0, 0, 0, 0, 0, 0]

for (let i = 0; i < 7; i++) {
  fish[i] = rawInput.filter((n) => i === n).length
}

// Fish at the head of the list spawn into the last position, while
// all other fish move one position to the left.
// Fish from the head position move to into the 7th position, adding to those
// rotating in from 8th position.
// Note, this function mutates the list.
function spawnAndRotate(): void {
  let [zero, one, two, three, four, five, six, seven, eight] = fish
  fish = [one, two, three, four, five, six, seven + zero, eight, zero]
}

for (let i = 0; i < 80; i++) {
  spawnAndRotate()
}
console.log(
  "part 1",
  fish.reduce((a, b) => a + b)
)

for (let i = 80; i < 256; i++) {
  spawnAndRotate()
}
console.log(
  "part 2",
  fish.reduce((a, b) => a + b)
)
