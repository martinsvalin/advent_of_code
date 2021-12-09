import { readFileSync } from "fs"
type Display = { signalPatterns: string[]; output: string[] }
let input: Display[] = readFileSync("../input/08")
  .toString()
  .trim()
  .split("\n")
  .map((line: string): string[] => line.split(" | ", 2))
  .map(([signals, output]) => ({ signalPatterns: signals.split(" "), output: output.split(" ") }))

let segments = {
  zero: 6,
  one: 2,
  two: 5,
  three: 5,
  four: 4,
  five: 5,
  six: 6,
  seven: 3,
  eight: 7,
  nine: 6,
}

// Part 1, count patterns with unique length in output
console.log(
  "part 1",
  input
    .flatMap(({ output }) => output)
    .filter((output) =>
      [segments.one, segments.four, segments.seven, segments.eight].includes(output.length)
    ).length
)

function overlap(left: string, right: string): boolean {
  let chars = right.split("")
  return left.split("").filter((char) => chars.includes(char)).length === right.length
}

function deduce(display: Display): number {
  let candidates: { [digit: string]: string[] } = {}

  Object.entries(segments).forEach(
    ([digit, segments]) =>
      (candidates[digit] = display.signalPatterns.filter((pattern) => pattern.length === segments))
  )
  // One, Four, Seven and Eight are already given

  // Zero is the only 6-segment digit that overlaps One but not Four
  // Six is the only 6-segment digit that does not overlap One
  // Nine is the only 6-segment digit that overlaps Four
  candidates.zero = candidates.zero.filter(
    (zero) => overlap(zero, candidates.one[0]) && !overlap(zero, candidates.four[0])
  )
  candidates.six = candidates.six.filter((six) => !overlap(six, candidates.one[0]))
  candidates.nine = candidates.nine.filter((nine) => overlap(nine, candidates.four[0]))

  // Two does not overlap One
  // Three is the only 5-segment digit to overlap One
  // Five is the only 5-segment digit overlapped by six,
  candidates.two = candidates.two.filter((two) => !overlap(two, candidates.one[0]))
  candidates.three = candidates.three.filter((three) => overlap(three, candidates.one[0]))
  candidates.five = candidates.five.filter((five) => overlap(candidates.six[0], five))

  // Two is not Five
  candidates.two = candidates.two.filter((two) => two !== candidates.five[0])

  // A list of patterns in order 0..9, with sorted characters
  let deducedDigits = [
    candidates.zero[0],
    candidates.one[0],
    candidates.two[0],
    candidates.three[0],
    candidates.four[0],
    candidates.five[0],
    candidates.six[0],
    candidates.seven[0],
    candidates.eight[0],
    candidates.nine[0],
  ].map((pattern) => pattern.split("").sort().join(""))

  return readOutput(deducedDigits, display.output)
}

// Sort characters in output patterns, then find its index among the deduced digits
// That's the digit. Now build the number from thousands, hundreds, tens and ones.
function readOutput(deducedDigits: string[], output: string[]): number {
  let comparableOutput = output.map((pattern) => pattern.split("").sort().join(""))

  let [thousands, hundreds, tens, ones] = comparableOutput.map((pattern) =>
    deducedDigits.findIndex((digit) => digit === pattern)
  )
  return thousands * 1000 + hundreds * 100 + tens * 10 + ones
}

let part2 = input.map((display) => deduce(display)).reduce((a, b) => a + b)

console.log("part 2", part2)
