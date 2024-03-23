(import (scheme base) (scheme char) (srfi 1) (srfi 13) (srfi 27) (srfi 28))

(define (get-yes-no prompt)
  (display (string-append prompt " (y/n) "))
  (define ans (string-foldcase (string-trim-both (read-line))))
  (cond ((equal? ans "y") #t)
        ((equal? ans "n") #f)
        (else (get-yes-no prompt))))

(define (random-not-in max-num list)
  (let ((num (+ (random-integer max-num) 1)))
    (if (member num list) (random-not-in max-num list) num)))

(define (random-nums max-num count)
  (if (<= count 0) '()
    (let ((rest (random-nums max-num (- count 1))))
      (cons (random-not-in max-num rest) rest))))

(define (loop nums)
  (display "Your guess: ")
  (define guess (string->number (string-trim-both (read-line))))
  (if (not guess) (loop nums) (let ()

    (define nums' (delete guess nums))
    (if (null? nums') (display "You've found the last number, congratulations!\n") (let ()
      (define did-find-any (member guess nums))
      (when did-find-any (display "That's one of the numbers, good job!\n"))

      (define lessc (length (filter (lambda (x) (< x guess)) nums')))
      (define greaterc (- (length nums') lessc))
      (display (if did-find-any "Still, too " "Too "))
      (when (> lessc 0) (display (if (= lessc 1) "high" (format "high for ~a" lessc))))
      (when (and (> lessc 0) (> greaterc 0)) (display " and too "))
      (when (> greaterc 0) (display (if (= greaterc 1) "low" (format "low for ~a" greaterc))))
      (display "!\n")

      (loop nums'))))))

(define (game max-num numc)
  (display (format "Guess the ~a from 1 to ~a.\n" (if (= numc 1) "number" (format "~a numbers" numc)) max-num))
  (loop (random-nums max-num numc))
  (when (get-yes-no "Do you want to play again?") (game max-num numc)))

(display "Welcome to The Miraculous Game of Zgadywanko!\n")

(when (> (length (command-line)) 3) (error "Too many arguments"))
(define max-num (guard (_ (100)) (string->number (list-ref (command-line) 1))))
(define numc (guard (_ (1)) (string->number (list-ref (command-line) 2))))
(when (< numc 1) (error "The number of numbers must not be less than 1"))
(when (< max-num numc) (error (format "The upper bound must not be less than ~a" numc)))

(random-source-randomize! default-random-source)
(game max-num numc)
(display "Thanks for playing, bye!\n")
