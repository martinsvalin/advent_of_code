import advent2019.intcode.Intcode
import kotlin.test.assertEquals
import kotlin.test.assertFails
import org.junit.Test as test

class IntcodeTest {
    @test
    fun addition() {
        assertEquals(2, Intcode("1,0,0,0,99").run().read(0))
        assertEquals(4, Intcode("1,0,0,0,1,0,0,0,99").run().read(0))
    }

    @test
    fun multiplication() {
        assertEquals(4, Intcode("2,0,0,0,99").run().read(0))
        assertEquals(16, Intcode("2,0,0,0,2,0,0,0,99").run().read(0))
    }

    @test
    fun verb_noun() {
        assertEquals(100, Intcode("1,-1,-1,0,99").run(0, 4).read(0))
    }

    @test
    fun error() {
        assertFails { Intcode("-1,99").run() }
    }

    @test
    fun no_exit() {
        assertFails { Intcode("1,0,0,0").run() }
    }
}
