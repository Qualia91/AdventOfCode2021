
namespace Day10 {
  
    class Day10 {
    
        static void Main(string[] args)
        {
            System.Console.WriteLine("Hello World!");

            string[] lines = System.IO.File.ReadAllLines(@"testInput.txt");

            // Display the file contents by using a foreach loop.
            System.Console.WriteLine("Contents of testInput.txt = ");
            foreach (string line in lines)
            {
                // Use a tab to indent each line of the file.
                Console.WriteLine(line);
            }
        }
    }
}