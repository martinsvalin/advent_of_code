import { readFileSync } from "fs"

type closing = ")" | "]" | "}" | ">"
type result = { result: "ok"; stack: closing[] } | { result: "illegalCharacter"; character: string }

let lines: string[] = readFileSync("../input/10").toString().trim().split("\n")

let chars: { [key: string]: closing } = { "(": ")", "[": "]", "{": "}", "<": ">" }
let syntaxScore: { [key: string]: number } = {
  ")": 3,
  "]": 57,
  "}": 1197,
  ">": 25137,
}
let autocompleteScore: { [key: string]: number } = {
  ")": 1,
  "]": 2,
  "}": 3,
  ">": 4,
}

function checkSyntax(line: string): result {
  let stack: closing[] = []

  for (let char of line) {
    if (chars[char]) {
      stack.unshift(chars[char])
    } else if (char === stack[0]) {
      stack.shift()
    } else {
      return { result: "illegalCharacter", character: char }
    }
  }
  return { result: "ok", stack: stack }
}

let results = lines.map(checkSyntax)

console.log(
  "part 1",
  results.reduce(
    (sum, result) => (result.result === "ok" ? sum : sum + syntaxScore[result.character]),
    0
  )
)

let scores = results
  .map((result) =>
    result.result === "ok"
      ? result.stack.reduce((score, char) => score * 5 + autocompleteScore[char], 0)
      : 0
  )
  .filter((nonZero) => nonZero)
  .sort((a, b) => a - b)

console.log("part 2", scores[Math.floor(scores.length / 2)])
