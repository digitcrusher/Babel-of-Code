import java.math.BigInteger
import java.util.concurrent.ThreadLocalRandom

fun getYesNo(prompt: String): Boolean {
  print("${prompt} (y/n) ")
  return when(readln().trim().lowercase()) {
    "y" -> true
    "n" -> false
    else -> getYesNo(prompt)
  }
}

fun randBigInt(a: BigInteger, b: BigInteger): BigInteger {
  var result: BigInteger
  do {
    result = BigInteger((b - a).bitLength(), ThreadLocalRandom.current())
  } while(result > b - a)
  return result + a
}

fun main(args: Array<String>) {
  println("Welcome to The Miraculous Game of Zgadywanko!")

  require(args.size <= 2) { "Too many arguments" }
  val maxNum = args.getOrNull(0)?.toBigInteger() ?: BigInteger.valueOf(100)
  val numc = args.getOrNull(1)?.toInt() ?: 1
  require(numc >= 1) { "The number of numbers must not be less than 1" }
  require(maxNum >= BigInteger.valueOf(numc.toLong())) { "The upper bound must not be less than ${numc}" }

  do {
    println("Guess the " + (if(numc == 1) "number" else "${numc} numbers") + " from 1 to ${maxNum}.")
    val nums = generateSequence { randBigInt(BigInteger.ONE, maxNum) }.distinct().take(numc).toMutableSet()

    while(true) {
      print("Your guess: ")
      val guess = try {
        readln().trim().toBigInteger()
      } catch(_: NumberFormatException) {
        continue
      }

      val didFindAny = nums.remove(guess)
      if(nums.isEmpty()) {
        println("You've found the last number, congratulations!")
        break
      } else if(didFindAny) {
        println("That's one of the numbers, good job!")
      }

      val lessc = nums.count { it < guess }
      val greaterc = nums.size - lessc
      print(if(didFindAny) "Still, too " else "Too ")
      if(lessc > 0) {
        print(if(lessc == 1) "high" else "high for ${lessc}")
      }
      if(lessc > 0 && greaterc > 0) {
        print(" and too ")
      }
      if(greaterc > 0) {
        print(if(greaterc == 1) "low" else "low for ${greaterc}")
      }
      println("!")
    }

  } while(getYesNo("Do you want to play again?"))

  println("Thanks for playing, bye!")
}
