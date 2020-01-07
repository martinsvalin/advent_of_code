package advent2019.intcode

class Intcode(source: String) {
    private val code = loadSource(source)
    private var current = 0

    private fun loadSource(source: String): MutableMap<Int, Int> {
        return source
            .split(",")
            .mapIndexed { index, value -> index to value.toInt() }
            .toMap()
            .toMutableMap()
    }

    fun run(verb: Int, noun: Int): Intcode {
        code.put(1, verb)
        code.put(2, noun)
        return run()
    }

    tailrec fun run(): Intcode {
        when (read(current)) {
            1 -> add()
            2 -> multiply()
            99 -> return this
            else -> error("unknown operator ${read(current)}")
        }
        return run()
    }

    fun read(position: Int): Int {
        return code[position] ?: error("unknown position $position")
    }

    private fun add() {
        val sum = read(read(current + 1)) + read(read(current + 2))
        code.put(read(current + 3), sum)
        step(4)
    }

    private fun multiply() {
        val product = read(read(current + 1)) * read(read(current + 2))
        code.put(read(current + 3), product)
        step(4)
    }

    private fun step(n: Int) {
        current += n
    }
}
