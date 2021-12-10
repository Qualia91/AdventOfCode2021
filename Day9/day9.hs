import System.IO
import Control.Monad
import Data.Char(digitToInt)
import Debug.Trace 
import Data.List

data Coord = Coord Int Int Int deriving Show
data Point = Point Coord [Coord] deriving Show

main = do
    contents <- readFile "input.txt"
    let matrix = createInputMatrix (lines contents)

    let xLength = ((length matrix) - 1)
    let yLength = ((length (matrix !! 0)) - 1)

    let indices = [(x,y) | x <- [0..xLength], y <- [0..yLength]]

    -- part one
    let points = foldl (\acc (x, y) -> (createPoint x y matrix) : acc) [] indices
    let minPoints = foldl (\acc point -> addMinPoint (isMinPoint point) point acc) [] points
    let partOne = foldl (\sum (Point (Coord _ _ val) _) -> sum + val + 1) 0 minPoints

    -- part two - flood fill
    let partTwo = product $ take 3 $ sortOn negate $ foldl (\basinsAcc lowPoint -> length (findBasin lowPoint points []) : basinsAcc) [] minPoints

    print ("Part One Answer: " ++ show partOne ++ " - Part Two Answer: " ++ show partTwo)

addMinPoint :: Bool -> Point -> [Point] -> [Point]
addMinPoint True point sum = point : sum
addMinPoint False _ sum = sum

isMinPoint :: Point -> Bool
isMinPoint (Point (Coord x y val) []) = True
isMinPoint (Point (Coord x y val) ((Coord _ _ checkVal) : rest)) 
 | val <= checkVal = isMinPoint (Point (Coord y x val) rest) 
 | otherwise = False

searchForPoint :: Coord -> [Point] -> Maybe Point
searchForPoint _ [] = Nothing
searchForPoint (Coord inX inY _) ((Point (Coord x y val) neighbours) : points) 
 | (inX == x) && (inY == y) = Just (Point (Coord x y val) neighbours)
 | otherwise = searchForPoint (Coord inX inY val) points

createPoint :: Int -> Int -> [[Int]] -> Point
createPoint indexX indexY matrix = do
    let entry = matrix !! indexX !! indexY

    let Just (neightbourPoints, _) = addNeighbour (indexX-1) indexY ([], matrix) >>= addNeighbour (indexX+1) indexY >>= addNeighbour indexX (indexY-1) >>= addNeighbour indexX (indexY+1)

    (Point (Coord indexX indexY entry) neightbourPoints)

addNeighbour :: Int -> Int -> ([Coord], [[Int]]) -> Maybe ([Coord], [[Int]])
addNeighbour indexX indexY (points, matrix)
 | indexX >= 0 && indexY >= 0 = case nthelem indexY (nthelem indexX (Just matrix)) of
    Nothing -> Just (points, matrix)
    Just val  -> Just (((Coord indexX indexY val) : points), matrix)
 | otherwise = Just (points, matrix)

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

notAlreadyVisited :: Coord -> [Coord] -> Bool
notAlreadyVisited (Coord x y val) [] = True
notAlreadyVisited (Coord inX inY val) ((Coord x y _) : visited)
  | inX == x && inY == y = False
  | otherwise = notAlreadyVisited (Coord inX inY val) visited

extract :: Maybe a -> a
extract (Just val) = val

getAllowedNeighbours :: [Coord] -> [Coord] -> [Coord]
getAllowedNeighbours visited [] = []
getAllowedNeighbours visited ((Coord x y val) : rest)
  | val /= 9 && notAlreadyVisited (Coord x y val) visited = (Coord x y val) : getAllowedNeighbours visited rest
  | otherwise = getAllowedNeighbours visited rest

findBasin :: Point -> [Point] -> [Coord] -> [Coord]
findBasin (Point _ []) points visited = visited
findBasin (Point inCoord neighbours) points visited 
  | notAlreadyVisited inCoord visited = foldl (\acc allowedNeighbourCoord -> findBasin (extract (searchForPoint allowedNeighbourCoord points)) points acc) (inCoord : visited) (getAllowedNeighbours visited neighbours) 
  | otherwise = visited


