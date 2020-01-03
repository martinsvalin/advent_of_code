import org.junit.Test as test
import kotlin.test.assertEquals
import advent2019.day01.*

class Day01Test {
    @test fun fuel() {
        assertEquals(fuel(14), 2)
        assertEquals(fuel(1969), 654)
        assertEquals(fuel(100756), 33583)
    }

    @test fun fuel_recursively() {
        assertEquals(fuel_recursively(14), 2)
        assertEquals(fuel_recursively(1969), 966)
        assertEquals(fuel_recursively(100756), 50346)
    }
}