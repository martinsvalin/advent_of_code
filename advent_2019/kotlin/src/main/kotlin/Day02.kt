import advent2019.intcode.Intcode

fun main() {
    val source = 1.javaClass.getResource("day02.txt").readText()
    println("Day 2, part 1: ${part1(source)}")
    println("Day 2, part 2: ${part2(source)}")
}

fun part1(source: String): Int =
    Intcode(source).run(12, 2).read(0)

fun part2(source: String): Int {
    for (verb in 0..99) {
        for (noun in 0..99) {
            val needle = Intcode(source).run(verb, noun).read(0)
            if (needle == 19_690_720) {
                return verb * 100 + noun
            }
        }
    }
    error("no combination found")
}
