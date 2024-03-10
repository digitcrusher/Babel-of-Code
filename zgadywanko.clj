(require '[clojure.string :as str])

(defn get-yes-no [prompt]
  (print prompt "(y/n) ")
  (flush)
  (case (-> (read-line) str/trim str/lower-case)
    "y" true
    "n" false
    (recur prompt)))

(defn rand-big-int [a b]
  (let [result (BigInteger. (.bitLength (- b a)) (java.util.concurrent.ThreadLocalRandom/current))]
    (if (<= result (- b a)) (+ result a) (recur a b))))

(defn get-num [prompt]
  (print prompt "")
  (flush)
  (try (-> (read-line) str/trim bigint)
    (catch NumberFormatException _ (get-num prompt))))

(defn loop [nums]
  (def guess (get-num "Your guess:"))

  (def nums' (disj nums guess))
  (if (empty? nums') (println "You've found the last number, congratulations!") (do
    (def did-find-any (contains? nums guess))
    (when did-find-any (println "That's one of the numbers, good job!"))

    (def lessc (count (filter #(< % guess) nums')))
    (def greaterc (- (count nums') lessc))
    (print (if did-find-any "Still, too " "Too "))
    (when (> lessc 0) (print (if (= lessc 1) "high" (str "high for " lessc))))
    (when (and (> lessc 0) (> greaterc 0)) (print " and too "))
    (when (> greaterc 0) (print (if (= greaterc 1) "low" (str "low for " greaterc))))
    (println "!")

    (loop nums'))))

(defn game [max-num numc]
  (printf "Guess the %s from 1 to %d.\n" (if (= numc 1) "number" (str numc " numbers")) (biginteger max-num))
  (loop (->> #(rand-big-int 1N max-num) repeatedly distinct (take numc) set))
  (when (get-yes-no "Do you want to play again?") (recur max-num numc)))

(println "Welcome to The Miraculous Game of Zgadywanko!")

(when (> (count *command-line-args*) 2) (throw (Exception. "Too many arguments")))
(def max-num (nth (map bigint *command-line-args*) 0 100))
(def numc (nth (map #(Integer/parseInt %) *command-line-args*) 1 1))
(when (< numc 1) (throw (Exception. "The number of numbers must not be less than 1")))
(when (< max-num numc) (throw (Exception. (str "The upper bound must not be less than " numc))))

(game max-num numc)
(println "Thanks for playing, bye!")
