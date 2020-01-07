package advent2019.aoc

fun input(day: Int): String =
    input("day${day.toString().padStart(2, '0')}.txt")

fun input(filename: String): String =
    1.javaClass.getResource(filename).readText()
