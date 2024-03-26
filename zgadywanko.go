package main

import (
  "bufio"
  "fmt"
  "math/big"
  "math/rand"
  "os"
  "strconv"
  "strings"
  "time"
)

var input = bufio.NewReader(os.Stdin)

func getYesNo(prompt string) (bool, error) {
  for {
    fmt.Print(prompt, " (y/n) ")
    ans, err := input.ReadString('\n')
    if err != nil {
      return false, err
    }
    switch strings.ToLower(strings.TrimSpace(ans)) {
      case "y": return true, nil
      case "n": return false, nil
    }
  }
}

func main() {
  fmt.Println("Welcome to The Miraculous Game of Zgadywanko!")

  if len(os.Args) > 3 {
    panic("Too many arguments")
  }
  maxNum := big.NewInt(100)
  if 1 < len(os.Args) {
    maxNum.SetString(os.Args[1], 10)
  }
  numc := 1
  if 2 < len(os.Args) {
    var err error
    numc, err = strconv.Atoi(os.Args[2])
    if err != nil {
      panic(err)
    }
  }
  if numc < 1 {
    panic("The number of numbers must not be less than 1")
  }
  if maxNum.Cmp(big.NewInt(int64(numc))) < 0 {
    panic(fmt.Sprint("The upper bound must not be less than ", numc))
  }

  rng := rand.New(rand.NewSource(time.Now().UnixNano()))

  for {
    fmt.Print("Guess the ")
    if numc == 1 {
      fmt.Print("number")
    } else {
      fmt.Print(numc, " numbers")
    }
    fmt.Print(" from 1 to ", maxNum, ".\n")

    nums := make(map[*big.Int]struct{})
    for len(nums) < numc {
      newNum := new(big.Int).Rand(rng, maxNum)
      newNum.Add(newNum, big.NewInt(1))

      isDistinct := true
      for num := range nums {
        if newNum.Cmp(num) == 0 {
          isDistinct = false
          break
        }
      }
      if isDistinct {
        nums[newNum] = struct{}{}
      }
    }

    for {
      fmt.Print("Your guess: ")
      read, err := input.ReadString('\n')
      if err != nil {
        panic(err)
      }
      guess, ok := new(big.Int).SetString(strings.TrimSpace(read), 10)
      if !ok {
        continue
      }

      didFindAny := false
      for num := range nums {
        if num.Cmp(guess) == 0 {
          delete(nums, num)
          didFindAny = true
        }
      }
      if len(nums) <= 0 {
        fmt.Println("You've found the last number, congratulations!")
        break
      } else if didFindAny {
        fmt.Println("That's one of the numbers, good job!")
      }

      lessc, greaterc := 0, 0
      for num := range nums {
        if num.Cmp(guess) < 0 {
          lessc++
        } else {
          greaterc++
        }
      }
      if didFindAny {
        fmt.Print("Still, too ")
      } else {
        fmt.Print("Too ")
      }
      if lessc == 1 {
        fmt.Print("high")
      } else if lessc > 0 {
        fmt.Print("high for ", lessc)
      }
      if lessc > 0 && greaterc > 0 {
        fmt.Print(" and too ")
      }
      if greaterc == 1 {
        fmt.Print("low")
      } else if greaterc > 0 {
        fmt.Print("low for ", greaterc)
      }
      fmt.Println("!")
    }

    shouldContinue, err := getYesNo("Do you want to play again?")
    if err != nil {
      panic(err)
    } else if !shouldContinue {
      break
    }
  }

  fmt.Println("Thanks for playing, bye!")
}
