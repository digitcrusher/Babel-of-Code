(require math)

(define (get-yes-no prompt)
  (display (string-append prompt " (y/n) "))
  (case (string-foldcase (string-trim (read-line)))
    [("y") #t]
    [("n") #f]
    [else (get-yes-no prompt)]))

(define (random-not-in max-num list)
  (let ([num (+ (random-natural max-num) 1)])
    (if (member num list) (random-not-in max-num list) num)))

(define (random-nums max-num count)
  (if (<= count 0) '()
    (let ([rest (random-nums max-num (- count 1))])
      (cons (random-not-in max-num rest) rest))))

(define (loop nums)
  (display "Your guess: ")
  (define guess (string->number (string-trim (read-line))))
  (if (not guess) (loop nums) (let ()

    (define new-nums (remove guess nums))
    (if (null? new-nums) (displayln "You've found the last number, congratulations!") (let ()
      (define did-find-any (member guess nums))
      (when did-find-any (displayln "That's one of the numbers, good job!"))

      (define lessc (length (filter (λ (x) (< x guess)) new-nums)))
      (define greaterc (- (length new-nums) lessc))
      (display (if did-find-any "Still, too " "Too "))
      (when (> lessc 0) (display (if (= lessc 1) "high" (~a "high for " lessc))))
      (when (and (> lessc 0) (> greaterc 0)) (display " and too "))
      (when (> greaterc 0) (display (if (= greaterc 1) "low" (~a "low for " greaterc))))
      (displayln "!")

      (loop new-nums))))))

(define (game max-num numc)
  (printf "Guess the ~a from 1 to ~a.\n" (if (= numc 1) "number" (~a numc " numbers")) max-num)
  (loop (random-nums max-num numc))
  (when (get-yes-no "Do you want to play again?") (game max-num numc)))

(displayln "Welcome to The Miraculous Game of Zgadywanko!")

(when (> (vector-length (current-command-line-arguments)) 2) (error "Too many arguments"))
(define max-num (with-handlers ([exn:fail:contract? (λ _ 100)]) (string->number (vector-ref (current-command-line-arguments) 0))))
(define numc (with-handlers ([exn:fail:contract? (λ _ 1)]) (string->number (vector-ref (current-command-line-arguments) 1))))
(when (< numc 1) (error "The number of numbers must not be less than 1"))
(when (< max-num numc) (error "The upper bound must not be less than" numc))

(game max-num numc)
(displayln "Thanks for playing, bye!")
