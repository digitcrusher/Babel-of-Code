(fn get-yes-no [prompt]
  (io.write prompt " (y/n) ")
  (match (-> (io.read) (string.match "^%s*(.-)%s*$") string.lower)
    "y" true
    "n" false
    _ (get-yes-no prompt)))

(fn random-not-in [set_ ...]
  (let [num (math.random ...)]
    (if (. set_ num) (random-not-in set_ ...) num)))

(fn loop [nums]
  (io.write "Your guess: ")
  (local guess (io.read :*num))
  (io.read)
  (if (= guess nil) (loop nums) (do

    (local did-find-any (. nums guess))
    (tset nums guess nil)
    (if (= (next nums) nil) (io.write "You've found the last number, congratulations!\n") (do
      (when did-find-any (io.write "That's one of the numbers, good job!\n"))

      (var [lessc greaterc] [0 0])
      (each [num _ (pairs nums)]
        (if (< num guess)
            (set lessc (+ lessc 1))
            (set greaterc (+ greaterc 1))))
      (io.write (if did-find-any "Still, too " "Too "))
      (when (> lessc 0) (io.write (if (= lessc 1) "high" (.. "high for " lessc))))
      (when (and (> lessc 0) (> greaterc 0)) (io.write " and too "))
      (when (> greaterc 0) (io.write (if (= greaterc 1) "low" (.. "low for " greaterc))))
      (io.write "!\n")

      (loop nums))))))

(fn game [max-num numc]
  (io.write "Guess the " (if (= numc 1) "number" (.. numc " numbers")) " from 1 to " max-num ".\n")
  (local nums {})
  (for [_ 1 numc] (tset nums (random-not-in nums max-num) true))
  (loop nums)
  (when (get-yes-no "Do you want to play again?") (game max-num numc)))

(io.write "Welcome to The Miraculous Game of Zgadywanko!\n")

(assert (<= (length arg) 2) "Too many arguments")
(local max-num (or (tonumber (. arg 1)) 100))
(local numc (or (tonumber (. arg 2)) 1))
(assert (>= numc 1) "The number of numbers must not be less than 1")
(assert (>= max-num numc) (.. "The upper bound must not be less than " numc))

(math.randomseed (os.time))
(game max-num numc)
(io.write "Thanks for playing, bye!\n")
