import { readFileSync } from "fs"

type board = { original: number[][]; withColumnsAddedAsRows: number[][]; index: number }

let rawInput = readFileSync("../input/04").toString()
let [rawDrawNumbers, ...rawBoards] = rawInput.split("\n\n")

let drawNumbers: number[] = rawDrawNumbers.split(",").map((s: string) => parseInt(s))
let boards: (board | undefined)[] = rawBoards
  .map((rawBoard) =>
    rawBoard.split("\n").map((line) =>
      line
        .trim()
        .split(/\s+/) // GAH!! When you split on one literal space, you parseInt some NaN from the extra spaces in "13 25  4 23  3"
        .map((n: string) => parseInt(n))
    )
  )
  .map(addColumnsAsRows)

// We need to find BINGO in both rows and columns. I guess it'll be easier if we
// simply add the columns as more rows. Now we just have to consider rows. 💡
function addColumnsAsRows(original: number[][], index: number): board {
  let columns = original[0].map((_, i) => original.map((row) => row[i]))
  return { original, withColumnsAddedAsRows: original.concat(columns), index }
}

let drawn: number[] = []
let winner: board | undefined
while (!winner) {
  // We know more than the typesystem: draw numbers won't run out. And -1 is not on any board
  drawn.unshift(drawNumbers.shift() ?? -1)
  winner = boards.find(bingo)
}

// Determine if a board has BINGO. Some row must have all numbers drawn
function bingo(board: board | undefined): boolean {
  return !!board && board.withColumnsAddedAsRows.some((row) => row.every((n) => drawn.includes(n)))
}

function score(board: board): number {
  const flatten = (list2d: any[][]): any[] => list2d.reduce((flat, inner) => flat.concat(inner))
  return (
    flatten(board.original)
      .filter((n) => !drawn.includes(n))
      .reduce((sum, n) => sum + n) * drawn[0]
  )
}

console.log("part 1", score(winner))

// Start over for part 2
drawNumbers = drawn.reverse().concat(drawNumbers)
drawn = []
let winners: (board | undefined)[] = []

// Draw until all boards have won
while (winners.length < boards.length) {
  drawn.unshift(drawNumbers.shift() ?? -1)
  let newWinners = boards.filter(bingo)
  newWinners.forEach((winner) => winner && (boards[winner.index] = undefined))
  winners = winners.concat(newWinners)
}

// Loser is the last winner
let loser: board | undefined = winners[winners.length - 1]

console.log("part 2", loser && score(loser))
