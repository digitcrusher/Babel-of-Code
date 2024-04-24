package zgadywanko

import "core:bufio"
import "core:fmt"
import "core:io"
import "core:math/big"
import "core:os"
import "core:strconv"
import "core:strings"

input: bufio.Reader

get_yes_no :: proc(prompt: string) -> (bool, io.Error) {
  for {
    fmt.print(prompt, "(y/n) ")
    read, err := bufio.reader_read_string(&input, '\n')
    defer delete(read)
    if err != nil {
      return false, err
    }
    ans := strings.to_lower(strings.trim_space(read))
    defer delete(ans)
    switch ans {
      case "y": return true, nil
      case "n": return false, nil
    }
  }
}

rand_big_int :: proc(dest, a, b: ^big.Int) -> big.Error {
  b_minus_a := &big.Int{}
  defer big.destroy(b_minus_a)
  big.sub(b_minus_a, b, a)
  bitc, err := big.count_bits(b_minus_a)
  if err != nil {
    return err
  }

  for {
    big.random(dest, bitc)
    if x, _ := big.lteq(dest, b_minus_a); x do break
  }
  big.add(dest, dest, a)
  return nil
}

main :: proc() {
  fmt.println("Welcome to The Miraculous Game of Zgadywanko!")

  if len(os.args) > 3 {
    panic("Too many arguments")
  }
  max_num := &big.Int{}
  defer big.destroy(max_num)
  if 1 < len(os.args) {
    big.atoi(max_num, os.args[1])
  } else {
    big.set(max_num, 100)
  }
  numc := strconv.atoi(os.args[2]) if 2 < len(os.args) else 1
  if numc < 1 {
    panic("The number of numbers must not be less than 1")
  }
  numc_big := &big.Int{}
  defer big.destroy(numc_big)
  big.set(numc_big, numc)
  if x, _ := big.lt(max_num, numc_big); x {
    panic(fmt.tprint("The upper bound must not be less than", numc))
  }

  bufio.reader_init(&input, os.stream_from_handle(os.stdin))
  defer bufio.reader_destroy(&input)

  for {
    fmt.print("Guess the ")
    if numc == 1 {
      fmt.print("number")
    } else {
      fmt.print(numc, "numbers")
    }
    max_num_str, err := big.itoa(max_num)
    defer delete(max_num_str)
    if err != nil {
      panic(fmt.tprint(err))
    }
    fmt.println(" from 1 to ", max_num_str, ".", sep="")

    nums: [dynamic]big.Int
    defer delete(nums)
    for len(nums) < numc {
      new_num := &big.Int{}
      rand_big_int(new_num, big.INT_ONE, max_num)

      is_distinct := true
      for &num in nums {
        if x, _ := big.eq(new_num, &num); x {
          is_distinct = false
          break
        }
      }
      if is_distinct {
        append(&nums, new_num^)
      } else {
        big.destroy(new_num)
      }
    }

    for {
      fmt.print("Your guess: ")
      read, err := bufio.reader_read_string(&input, '\n')
      defer delete(read)
      if err != nil {
        panic(fmt.tprint(err))
      }
      guess := &big.Int{}
      defer big.destroy(guess)
      if big.atoi(guess, strings.trim_space(read)) != nil do continue

      did_find_any := false
      for i := 0; i < len(nums); {
        if x, _ := big.eq(&nums[i], guess); x {
          big.destroy(&nums[i])
          unordered_remove(&nums, i)
          did_find_any = true
        } else {
          i += 1
        }
      }
      if len(nums) <= 0 {
        fmt.println("You've found the last number, congratulations!")
        break
      } else if did_find_any {
        fmt.println("That's one of the numbers, good job!")
      }

      lessc, greaterc := 0, 0
      for &num in nums {
        if x, _ := big.lt(&num, guess); x {
          lessc += 1
        } else {
          greaterc += 1
        }
      }
      fmt.print("Still, too " if did_find_any else "Too ")
      if lessc == 1 {
        fmt.print("high")
      } else if lessc > 0 {
        fmt.print("high for", lessc)
      }
      if lessc > 0 && greaterc > 0 {
        fmt.print(" and too ")
      }
      if greaterc == 1 {
        fmt.print("low")
      } else if greaterc > 0 {
        fmt.print("low for", greaterc)
      }
      fmt.println("!")
    }

    should_continue, err2 := get_yes_no("Do you want to play again?")
    if err2 != nil {
      panic(fmt.tprint(err2))
    } else if !should_continue do break
  }

  fmt.println("Thanks for playing, bye!")
}
