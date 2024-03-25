import collection.mutable.Set
import io.StdIn.readLine
import util.Random

def getYesNo(prompt: String): Boolean =
  readLine(s"${prompt} (y/n) ").strip.toLowerCase match
    case "y" => true
    case "n" => false
    case _ => getYesNo(prompt)

def randBigInt(a: BigInt, b: BigInt): BigInt =
  val result = BigInt((b - a).bitLength, Random)
  if result <= b - a then
    result + a
  else
    randBigInt(a, b)

def getNum(prompt: String): BigInt =
  try
    BigInt(readLine(s"${prompt} ").strip)
  catch case _: NumberFormatException =>
    getNum(prompt)

@main
def main(args: String*) =
  println("Welcome to The Miraculous Game of Zgadywanko!")

  require(args.size <= 2, "Too many arguments")
  val maxNum = args.lift(0).fold(BigInt(100))(BigInt.apply)
  val numc = args.lift(1).fold(1)(_.toInt)
  require(numc >= 1, "The number of numbers must not be less than 1")
  require(maxNum >= numc, s"The upper bound must not be less than ${numc}")

  var shouldContinue = true
  while shouldContinue do
    println("Guess the " + (if numc == 1 then "number" else s"${numc} numbers") + s" from 1 to ${maxNum}.")
    val nums = Set.from(Iterator.continually(randBigInt(BigInt(1), maxNum)).distinct.take(numc))

    while nums.nonEmpty do
      val guess = getNum("Your guess:")

      val didFindAny = nums.remove(guess)
      if nums.isEmpty then
        println("You've found the last number, congratulations!")
      else
        if didFindAny then
          println("That's one of the numbers, good job!")

        val lessc = nums.count(_ < guess)
        val greaterc = nums.size - lessc
        print(if didFindAny then "Still, too " else "Too ")
        if lessc > 0 then
          print(if lessc == 1 then "high" else s"high for ${lessc}")
        if lessc > 0 && greaterc > 0 then
          print(" and too ")
        if greaterc > 0 then
          print(if greaterc == 1 then "low" else s"low for ${greaterc}")
        println("!")

    shouldContinue = getYesNo("Do you want to play again?")

  println("Thanks for playing, bye!")
