import java.util.concurrent.ThreadLocalRandom
import java.util.stream.Stream

input = System.in.newReader()

def getYesNo(prompt) {
  print "${prompt} (y/n) "
  switch(input.readLine().strip().toLowerCase()) {
    case 'y' -> true
    case 'n' -> false
    default -> getYesNo prompt
  }
}

def randBigInt(a, b) {
  do {
    result = new BigInteger((b - a).bitLength(), ThreadLocalRandom.current())
  } while(result > b - a)
  result + a
}

println 'Welcome to The Miraculous Game of Zgadywanko!'

if(args.length > 2) {
  throw new Exception('Too many arguments')
}
maxNum = args.toList()[0]?.toBigInteger() ?: BigInteger.valueOf(100)
numc = args.toList()[1]?.toInteger() ?: 1
if(numc < 1) {
  throw new Exception('The number of numbers must not be less than 1')
}
if(maxNum < numc) {
  throw new Exception("The upper bound must not be less than ${numc}")
}

do {
  println 'Guess the ' + (numc == 1 ? 'number' : "${numc} numbers") + " from 1 to ${maxNum}."
  nums = Stream.generate { randBigInt(BigInteger.ONE, maxNum) }.distinct().limit(numc).toSet()

  while(true) {
    print 'Your guess: '
    try {
      guess = input.readLine().strip().toBigInteger()
    } catch(NumberFormatException _) {
      continue
    }

    didFindAny = nums.remove guess
    if(nums.isEmpty()) {
      println "You've found the last number, congratulations!"
      break
    } else if(didFindAny) {
      println "That's one of the numbers, good job!"
    }

    lessc = nums.count { it < guess }
    greaterc = nums.size() - lessc
    print didFindAny ? 'Still, too ' : 'Too '
    if(lessc > 0) {
      print lessc == 1 ? 'high' : "high for ${lessc}"
    }
    if(lessc > 0 && greaterc > 0) {
      print ' and too '
    }
    if(greaterc > 0) {
      print greaterc == 1 ? 'low' : "low for ${greaterc}"
    }
    println '!'
  }

} while(getYesNo 'Do you want to play again?')

println 'Thanks for playing, bye!'
