import advent2019.intcode.Intcode
import kotlin.test.assertEquals
import org.junit.Test as test

class Day02Test {
    @test
    fun part1() {
        assertEquals(2, Intcode("1,0,0,0,99").run().read(0))
        assertEquals(6, Intcode("2,3,0,3,99").run().read(3))
        assertEquals(9801, Intcode("2,4,4,5,99,0").run().read(5))
        assertEquals(30, Intcode("1,1,1,4,99,5,6,0,99").run().read(0))
    }
}
