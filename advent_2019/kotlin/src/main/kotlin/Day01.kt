package advent2019.day01

fun main() {
    val lines = 1.javaClass.getResource("day01.txt").readText().lines()
    val mass = lines.map { it.toInt() }.sum()
    println("Day 1, part 1: ${fuel(mass)}")
    println("Day 1, part 2: ${fuel_recursively(mass)}")
}

/* Fuel for mass is mass divided by three rounded down, subtract 2 */
fun fuel(mass: Int): Int =
    mass / 3 - 2

/* Fuel for mass, accounting for added fuel */
tailrec fun fuel_recursively(mass: Int, total: Int = 0): Int {
    val fuel = fuel(mass)
    return if (fuel > 0) {
        fuel_recursively(fuel, total + fuel)
    } else {
        total
    }
}
