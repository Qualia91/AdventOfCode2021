using System;
using System.Collections.Generic;
using System.Linq; // to enable OPEN_CHARS.Contains

namespace Day10 {
  
    class Day10 {

        public const string OPEN_CHARS = "([{<";
        public const string CLOSE_CHARS = ")]}>";
        public Dictionary<char, int> valueDict = new Dictionary<char, int>();
        public Dictionary<char, char> closeMapping = new Dictionary<char, char>();
    
        static void Main(string[] args)
        {
            Day10 day10 = new Day10();
            Console.WriteLine("Part One: " + day10.PartOne());
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
        }

        public int PartOne() {
            string[] lines = System.IO.File.ReadAllLines(@"input.txt");

            Dictionary<char, int> errorCounter = new Dictionary<char, int>();

            foreach (string line in lines)
            {
                
                Stack<char> openStack = new Stack<char>();

                foreach (char c in line)
                {
                    if (OPEN_CHARS.Contains(c)) {
                        openStack.Push(c);
                    } else if (CLOSE_CHARS.Contains(c)) {
                        var next = closeMapping[openStack.Pop()];
                        if (next != c) {
                            errorCounter = AddToDict(c, errorCounter);
                        }
                    }
                
                }
            }
                
            return CalcErrors(errorCounter);
        }

        private Dictionary<char, int> AddToDict(char character, Dictionary<char, int> errorCounter) {
            if (errorCounter.ContainsKey(character)) {
                errorCounter[character] = errorCounter[character] + 1;
            } else {
                errorCounter[character] = 1;
            }
            return errorCounter;
        }

        private int CalcErrors(Dictionary<char, int> errorCounter) {
            int sum = 0;
            foreach(KeyValuePair<char, int> kvp in errorCounter ) {
                Console.WriteLine("Key = {0}, Value = {1}", kvp.Key, kvp.Value);
                sum += (valueDict[kvp.Key] * kvp.Value);
            }
            return sum;
        }
    }
}