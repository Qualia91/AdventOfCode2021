using System;
using System.Collections.Generic;
using System.Linq; // to enable OPEN_CHARS.Contains

namespace Day10 {
  
    class Day10 {

        public const string OPEN_CHARS = "([{<";
        public const string CLOSE_CHARS = ")]}>";
        public Dictionary<char, long> valueDict = new Dictionary<char, long>();
        public Dictionary<char, long> valueDictPartTwo = new Dictionary<char, long>();
        public Dictionary<char, char> closeMapping = new Dictionary<char, char>();
    
        static void Main(string[] args)
        {
            Day10 day10 = new Day10();
            Tuple<long, long> retTup = day10.Calculate();
            Console.WriteLine("Part One: " + retTup.Item1);
            Console.WriteLine("Part Two: " + retTup.Item2);
        }

        public Day10() {
            valueDict.Add(')', 3);
            valueDict.Add(']', 57);
            valueDict.Add('}', 1197);
            valueDict.Add('>', 25137);
            closeMapping.Add('(', ')');
            closeMapping.Add('[', ']');
            closeMapping.Add('{', '}');
            closeMapping.Add('<', '>');
            valueDictPartTwo.Add('(', 1);
            valueDictPartTwo.Add('[', 2);
            valueDictPartTwo.Add('{', 3);
            valueDictPartTwo.Add('<', 4);
        }

        public Tuple<long, long> Calculate() {
            string[] lines = System.IO.File.ReadAllLines(@"input.txt");

            Dictionary<char, long> errorCounter = new Dictionary<char, long>();

            List<long> partTwoLineResults = new List<long>();

            foreach (string line in lines)
            {
                
                Stack<char> openStack = new Stack<char>();

                bool failed = false;

                foreach (char c in line)
                {
                    if (OPEN_CHARS.Contains(c)) {
                        openStack.Push(c);
                    } else if (CLOSE_CHARS.Contains(c)) {
                        var next = closeMapping[openStack.Pop()];
                        if (next != c) {
                            failed = true;
                            errorCounter = AddToDict(c, errorCounter);
                        }
                    }
                
                }

                if (!failed) {
                    partTwoLineResults.Add(CalculatePartTwoResult(openStack));
                }
            }
                
            return new Tuple<long, long>(CalcErrors(errorCounter), Average(partTwoLineResults));
        }

        private Dictionary<char, long> AddToDict(char character, Dictionary<char, long> errorCounter) {
            if (errorCounter.ContainsKey(character)) {
                errorCounter[character] = errorCounter[character] + 1;
            } else {
                errorCounter[character] = 1;
            }
            return errorCounter;
        }

        private long CalcErrors(Dictionary<char, long> errorCounter) {
            long sum = 0;
            foreach(KeyValuePair<char, long> kvp in errorCounter ) {
                sum += (valueDict[kvp.Key] * kvp.Value);
            }
            return sum;
        }

        private long CalculatePartTwoResult(Stack<char> openStack) {
            long sum = 0;
            foreach(char nextCharacter in openStack) {
                sum *= 5;
                sum += valueDictPartTwo[nextCharacter];
            }
            return sum;
        }

        private long Average(List<long> partTwoLineResults) {
            partTwoLineResults.Sort();
            return partTwoLineResults[partTwoLineResults.Count / 2];
        }
    }
}