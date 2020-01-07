import advent2019.day01.fuel
import advent2019.day01.fuel_recursively
import kotlin.test.assertEquals
import org.junit.Test as test

class Day01Test {
    @test
    fun fuel() {
        assertEquals(2, fuel(14))
        assertEquals(654, fuel(1969))
        assertEquals(33583, fuel(100756))
    }

    @test
    fun fuel_recursively() {
        assertEquals(2, fuel_recursively(14))
        assertEquals(966, fuel_recursively(1969))
        assertEquals(50346, fuel_recursively(100756))
    }
}
