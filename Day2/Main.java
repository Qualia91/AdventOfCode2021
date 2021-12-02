
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

class Main {

    private static String FORWARD = "forward";
    private static String DOWN = "down";
    private static String UP = "up";

    private class IntPair {
        public int a;
        public int b;

        public IntPair(int A, int B) {
            this.a = A;
            this.b = B;
        }
    }

    public static void main(String[] args) throws IOException {
        Main main = new Main();

        IntPair ReturnPair = main.CalculateHorizontalAndDepth();

        System.out.println("Forward: " + ReturnPair.a + ", Depth: " + ReturnPair.b + ", Answer: " + (ReturnPair.a * ReturnPair.b));
    }

    private final String[] lines;

    public Main() throws IOException {
        String fileContents = Files.readString(Path.of("input.txt"));
        this.lines = fileContents.split("\n");
    }

    public IntPair CalculateHorizontalAndDepth() {
        int forward = 0;
        int depth = 0;
        int aim = 0;

        for (String line :  lines) {

            String[] inputs = line.split(" ");
            String command = inputs[0].replaceAll("\\s+", "");
            int val = Integer.parseInt(inputs[1].replaceAll("\\s+", ""));

            if (command.equals(FORWARD)) {
                forward += val;
                depth += (aim * val);
            } else if (command.equals(DOWN)) {
                aim += val;
            } else if (command.equals(UP)) {
                aim -= val;
            } else {
                System.out.println("No Match");
            }
            
        }

        return new IntPair(forward, depth);
    }
}