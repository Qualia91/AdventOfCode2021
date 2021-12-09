import System.IO
import Control.Monad
import Data.Char(digitToInt)
import Debug.Trace 

data LowPoint = LowPoint Int Int Int deriving Show

main = do
    contents <- readFile "testInput.txt"
    let matrix = createInputMatrix (lines contents)

    let xLength = ((length matrix) - 1)
    let yLength = ((length (matrix !! 0)) - 1)

    let indices = [(x,y) | x <- [0..xLength], y <- [0..yLength]]

    -- part one
    let lowPoints = foldl (\acc (x, y) -> (LowPoint (checkMatrixEntry x y matrix) x y) : acc) [] indices
    let partOne = foldl (\sum (LowPoint val _ _) -> sum + val) 0 lowPoints

    -- part two - flood fill
    let basicSizes = foldl (\basinSizesSum (LowPoint val x y) -> (findBasin x y matrix) : basinSizesSum) [] lowPoints

    print basicSizes

checkMatrixEntry :: Int -> Int -> [[Int]] -> Int
checkMatrixEntry indexX indexY matrix = do
    let entry = matrix !! indexX !! indexY

    let ret = checkIndex (indexX-1) indexY entry matrix >>= checkIndex (indexX+1) indexY entry >>= checkIndex indexX (indexY-1) entry >>= checkIndex indexX (indexY+1) entry

    returnIfJust ret (entry + 1)

returnIfJust :: Maybe a -> Int -> Int
returnIfJust Nothing _ = 0
returnIfJust (Just _) val = val

createInputMatrix :: [String] -> [[Int]]
createInputMatrix strList = [ map digitToInt str | str <- strList]

if' :: Bool -> a -> a -> a
if' True  x _ = x
if' False _ y = y

checkIndex :: Int -> Int -> Int -> [[Int]] -> Maybe [[Int]]
checkIndex indexX indexY inputVal matrix
 | indexX >= 0 && indexY >= 0 = case nthelem indexY (nthelem indexX (Just matrix)) of
    Nothing -> (Just matrix)
    Just val  -> if' (inputVal < val) (Just matrix) Nothing
 | otherwise = Just matrix

-- Based on https://stackoverflow.com/questions/15980989/haskell-get-nth-element-without
nthelem :: Int -> Maybe [a] -> Maybe a
nthelem _ Nothing = Nothing
nthelem _ (Just []) = Nothing
nthelem 0 (Just (x:xs)) = Just x
nthelem n (Just (x:xs)) = nthelem (n - 1) (Just xs)

findBasin :: Int -> Int -> [[Int]] -> Int
findBasin x y matrix = 1