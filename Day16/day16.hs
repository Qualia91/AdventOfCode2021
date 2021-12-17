import System.IO
import Control.Monad
import Data.Char(digitToInt)
import Debug.Trace 
import Data.List
import Numeric (readHex)
import Text.Printf (printf)

data BTree = Leaf Int Int | Branch Int Int [BTree]
  deriving (Eq,Show)

main = do
    -- contents <- readFile "testInputBasic.txt"
    -- contents <- readFile "testInputSubPacket.txt"
    -- contents <- readFile "testInputAnotherExample.txt"
    -- contents <- readFile "testInputAnotherExample2.txt"
    -- contents <- readFile "testInputAnotherExample3.txt"
    -- contents <- readFile "testInputAnotherExample4.txt"
    -- contents <- readFile "testInputAnotherExample5.txt"
    -- contents <- readFile "testInputP2E1.txt"
    -- contents <- readFile "testInputP2E2.txt"
    -- contents <- readFile "testInputP2E3.txt"
    -- contents <- readFile "testInputP2E4.txt"
    -- contents <- readFile "testInputP2E5.txt"
    -- contents <- readFile "testInputP2E6.txt"
    -- contents <- readFile "testInputP2E7.txt"
    -- contents <- readFile "testInputP2E8.txt"
    
    contents <- readFile "input.txt"

    let hex = foldl (\acc elem -> acc ++ (hex_to_bin elem)) [] [str | str <- contents]

    let (final, remaining) = foldl (\(acc, remainingStr) x -> do
        let (node, remaining) = parse_packet remainingStr
        ((node : acc), remaining)
        ) ([], hex) [1]

    let sumOfVersionNumbers = sum_version_numbers final

    let calculation = preform_calculation final

    print ("Part One Answer: " ++ (show sumOfVersionNumbers))
    print ("Part Two Answer: " ++ (show calculation))

preform_calculation :: [BTree] -> [Int]
preform_calculation [] = []
preform_calculation ((Leaf _ val):rst) = val : preform_calculation rst
preform_calculation ((Branch version 0 nodes):rst) = (sum $ preform_calculation nodes) : preform_calculation rst
preform_calculation ((Branch version 1 nodes):rst) = (product $ preform_calculation nodes) : preform_calculation rst
preform_calculation ((Branch version 2 nodes):rst) = (minimum $ preform_calculation nodes) : preform_calculation rst
preform_calculation ((Branch version 3 nodes):rst) = (maximum $ preform_calculation nodes) : preform_calculation rst
preform_calculation ((Branch version 5 nodes):rst) = (my_compare (<) $ preform_calculation nodes) : preform_calculation rst -- These next 2 are reversed as list creation reverses the inputs
preform_calculation ((Branch version 6 nodes):rst) = (my_compare (>) $ preform_calculation nodes) : preform_calculation rst
preform_calculation ((Branch version 7 nodes):rst) = (my_compare (==) $ preform_calculation nodes) : preform_calculation rst

bool_to_int :: Bool -> Int
bool_to_int True = 1
bool_to_int False = 0

my_compare :: (Int -> Int -> Bool) -> [Int] -> Int
my_compare func [fst,lst] = bool_to_int $ func fst lst

sum_version_numbers :: [BTree] -> Int
sum_version_numbers [] = 0
sum_version_numbers ((Leaf version _):rst) = version + sum_version_numbers rst
sum_version_numbers ((Branch version type_id nodes):rst) = version + sum_version_numbers rst + sum_version_numbers nodes

parse_packet :: [Char] -> (BTree, [Char])
parse_packet packetString = do

    let (version, type_id, rest_of_string) = parse_version_and_type packetString

    parse_packet_type version type_id rest_of_string

parse_packet_type :: Int -> Int -> [Char] -> (BTree, [Char])
parse_packet_type version 4 str = do

    let (literal_pack, string_after_packet) = parse_packet_contents str 4

    let literal_num = bin_to_dec literal_pack

    ((Leaf version literal_num), string_after_packet)
parse_packet_type version type_id str = do

    parse_sub_packet version type_id $ read_next 1 str
    
parse_sub_packet :: Int -> Int -> ([Char], [Char]) -> (BTree, [Char])
parse_sub_packet version type_id ("0", str) = do
    let (length_char, rest_of_string) = read_next 15 str
    
    let (packet_string, next_packets) = read_next (bin_to_dec length_char) rest_of_string

    let final = continue_parsing ([], packet_string)

    ((Branch version type_id final), next_packets)
parse_sub_packet version type_id ("1", str) = do
    let (number_of_sub_packets_char, rest_of_string) = read_next 11 str
    let number_of_sub_packets = bin_to_dec number_of_sub_packets_char

    let (final, remaining) = foldl (\(acc, remainingStr) x -> do
        let (node, remaining) = parse_packet remainingStr
        ((node : acc), remaining)
        ) ([], rest_of_string) [1..number_of_sub_packets]

    ((Branch version type_id final), remaining)

continue_parsing :: ([BTree], [Char]) -> [BTree]
continue_parsing (acc, []) = acc
continue_parsing (acc, remainingStr) = continue_parsing (add_to_acc (parse_packet remainingStr) acc)

-- parse_sub_packet "1" str = 
add_to_acc :: (BTree, [Char]) -> [BTree] -> ([BTree], [Char])
add_to_acc (node, remaining) acc = ((node : acc), remaining)

parse_version_and_type :: [Char] -> (Int, Int, [Char])
parse_version_and_type packetString = do
    let (version_str, rst) = read_next 3 packetString
    let (type_id_str, rst2) = read_next 3 rst

    let version = bin_to_dec version_str
    let type_id = bin_to_dec type_id_str

    (version, type_id, rst2)

parse_packet_contents :: [Char] -> Int -> ([Char], [Char])
parse_packet_contents packet_string 4 = read_numbers_literal packet_string []

read_numbers_literal :: [Char] -> [Char] -> ([Char], [Char])
read_numbers_literal [] acc = (acc, [])
read_numbers_literal ('0':str) acc = (acc ++ currentStr, rest)
    where (currentStr, rest) = read_next 4 str
read_numbers_literal ('1':str) acc = read_numbers_literal rest (acc ++ currentStr)
    where (currentStr, rest) = read_next 4 str

hex_to_bin :: Char -> [Char]
hex_to_bin hex = case readHex [hex] of
      (x,_):_ -> printf "%04b" (x::Int)
      _       -> "0"

bin_to_dec :: String -> Int
bin_to_dec = foldl' (\acc x -> acc * 2 + digitToInt x) 0

read_next :: Int -> [Char] -> ([Char], [Char])
read_next left list = read_next' left list []

read_next' :: Int -> [Char] -> [Char] -> ([Char], [Char])
read_next' 0 rest acc = (reverse acc, rest)
read_next' left [] acc = ([], [])
read_next' left (hd:rst) acc = read_next' (left - 1) rst (hd : acc)