import java.math.BigInteger;
import java.util.InputMismatchException;
import java.util.LinkedList;
import java.util.Scanner;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;
import java.util.stream.Stream;

class Zgadywanko {
  static final Scanner input = new Scanner(System.in);

  static boolean getYesNo(final String prompt) {
    while(true) {
      System.out.print(prompt + " (y/n) ");
      final var ans = input.next();
      if(ans.equalsIgnoreCase("y")) {
        return true;
      } else if(ans.equalsIgnoreCase("n")) {
        return false;
      }
    }
  }

  static BigInteger randBigInt(final BigInteger a, final BigInteger b) {
    BigInteger result;
    do {
      result = new BigInteger(b.subtract(a).bitLength(), ThreadLocalRandom.current());
    } while(result.compareTo(b.subtract(a)) > 0);
    return result.add(a);
  }

  public static void main(final String[] args) throws Exception {
    System.out.println("Welcome to The Miraculous Game of Zgadywanko!");

    if(args.length > 2) {
      throw new Exception("Too many arguments");
    }
    final var maxNum = 0 < args.length ? new BigInteger(args[0]) : BigInteger.valueOf(100);
    final var numc = 1 < args.length ? Integer.parseInt(args[1]) : 1;
    if(numc < 1) {
      throw new Exception("The number of numbers must not be less than 1");
    }
    if(maxNum.compareTo(BigInteger.valueOf(numc)) < 0) {
      throw new Exception("The upper bound must not be less than " + numc);
    }

    do {
      System.out.println("Guess the " + (numc == 1 ? "number" : numc + " numbers") + " from 1 to " + maxNum + ".");
      final var nums = Stream.generate(() -> randBigInt(BigInteger.ONE, maxNum)).distinct().limit(numc).collect(Collectors.toCollection(LinkedList::new));

      while(true) {
        System.out.print("Your guess: ");
        BigInteger guess;
        try {
          guess = input.nextBigInteger();
        } catch(InputMismatchException e) {
          input.next();
          continue;
        }

        final var didFindAny = nums.remove(guess);
        if(nums.isEmpty()) {
          System.out.println("You've found the last number, congratulations!");
          break;
        } else if(didFindAny) {
          System.out.println("That's one of the numbers, good job!");
        }

        final var lessc = nums.stream().filter(x -> x.compareTo(guess) < 0).count();
        final var greaterc = nums.size() - lessc;
        System.out.print(didFindAny ? "Still, too " : "Too ");
        if(lessc > 0) {
          System.out.print(lessc == 1 ? "high" : "high for " + lessc);
        }
        if(lessc > 0 && greaterc > 0) {
          System.out.print(" and too ");
        }
        if(greaterc > 0) {
          System.out.print(greaterc == 1 ? "low" : "low for " + greaterc);
        }
        System.out.println("!");
      }

    } while(getYesNo("Do you want to play again?"));

    System.out.println("Thanks for playing, bye!");
  }
}
