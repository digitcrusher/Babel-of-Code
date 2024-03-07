{-# LANGUAGE BlockArguments #-}

import Data.Char (isSpace, toLower)
import Data.List (delete, dropWhileEnd, partition)
import System.Environment (getArgs)
import System.IO (hFlush, stdout)
import System.Random.Stateful (uniformRM, globalStdGen)
import Text.Read (readMaybe)

replicateUniqueM :: (Monad m, Eq a) => Int -> m a -> m [a]
replicateUniqueM cnt action
  | cnt <= 0 = return []
  | otherwise = replicateUniqueM (cnt - 1) action >>= extend
  where
    extend rest = do
      num <- action
      if num `elem` rest then
        extend rest
      else
        return $ num : rest

ask :: String -> IO String
ask question = do
  putStr question
  putStr " "
  hFlush stdout
  getLine

getYesNo :: String -> IO Bool
getYesNo prompt = do
  ans <- ask $ prompt ++ " (y/n)"
  case map toLower $ dropWhileEnd isSpace $ dropWhile isSpace ans of
    "y" -> return True
    "n" -> return False
    _ -> getYesNo prompt

loop :: [Integer] -> IO ()
loop nums = do
  maybeGuess <- readMaybe <$> ask "Your guess:"
  case maybeGuess of
    Nothing -> loop nums
    Just guess ->
      let nums' = delete guess nums in
      if null nums' then
        putStrLn "You've found the last number, congratulations!"

      else do
        let didFindAny = guess `elem` nums
        putStr if didFindAny then "That's one of the numbers, good job!\n" else ""

        let (lessc, greaterc) = (\(a, b) -> (length a, length b)) $ partition (< guess) nums'
        putStr if didFindAny then "Still, too " else "Too "
        putStr case lessc of
          0 -> ""
          1 -> "high"
          x -> "high for " ++ show x
        putStr if lessc > 0 && greaterc > 0 then " and too " else ""
        putStr case greaterc of
          0 -> ""
          1 -> "low"
          x -> "low for " ++ show x
        putStrLn "!"

        loop nums'

game :: Integer -> Int -> IO ()
game maxNum numc = do
  putStrLn $ "Guess the " ++ (if numc == 1 then "number" else show numc ++ " numbers") ++ " from 1 to " ++ show maxNum ++ "."
  replicateUniqueM numc (uniformRM (1, maxNum) globalStdGen) >>= loop

  shouldContinue <- getYesNo "Do you want to play again?"
  if shouldContinue then
    game maxNum numc
  else
    return ()

main :: IO ()
main = do
  putStrLn "Welcome to The Miraculous Game of Zgadywanko!"

  args <- getArgs
  let
    (maxNum, numc) = case args of
      [] -> (100, 1)
      [a] -> (read a, 1)
      [a, b] -> (read a, read b)
      _ -> error "Too many arguments"
  if numc < 1 then
    error "The number of numbers must not be less than 1"
  else if maxNum < toInteger numc then
    error $ "The upper bound must not be less than " ++ show numc

  else do
    game maxNum numc
    putStrLn "Thanks for playing, bye!"
