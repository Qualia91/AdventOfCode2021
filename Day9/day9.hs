import System.IO
import Control.Monad


main = do
    contents <- readFile "testInput.txt"
    print . words $ contents
    -- same as print (words contents)