import { readFileSync } from "fs"

type closing = ")" | "]" | "}" | ">"
type result = { result: "ok"; stack: closing[] } | { result: "illegalCharacter"; character: string }

let lines: string[] = readFileSync("../input/10").toString().trim().split("\n")

let chars: { [key: string]: closing } = { "(": ")", "[": "]", "{": "}", "<": ">" }
let score: { [key: string]: number } = { ")": 3, "]": 57, "}": 1197, ">": 25137 }

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

console.log(
  "part 1",
  lines.map(checkSyntax).reduce((sum, result) => {
    if (result.result === "ok") {
      return sum
    } else {
      return sum + score[result.character]
    }
  }, 0)
)
