
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

class Main {

    private static String FORWARD = "forward";
    private static String DOWN = "down";
    private static String UP = "up";

    public static void main(String[] args) throws IOException {

        Main main = new Main();

        System.out.println("Part One: " + main.calcPartOne());
        System.out.println("Part Two: " + main.calcPartTwo());        

    }

    private final String[] lines;

    public Main() throws IOException {
        String fileContents = Files.readString(Path.of("input.txt"));
        this.lines = fileContents.split("\n");
    }

    public int calcPartOne() {
        int forward = 0;
        int depth = 0;

        for (String line : lines) {

            String[] inputs = line.split(" ");
            String command = inputs[0];
            int val = Integer.parseInt(inputs[1].replaceAll("\\s+", ""));

            if (command.equals(FORWARD)) {
                forward += val;
            } else if (command.equals(DOWN)) {
                depth += val;
            } else if (command.equals(UP)) {
                depth -= val;
            } else {
                System.out.println("No Match Found");
            }

        }

        return forward * depth;
    }

    public int calcPartTwo() {
        int forward = 0;
        int depth = 0;
        int aim = 0;

        for (String line : lines) {

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
                System.out.println("No Match Found");
            }

        }

        return forward * depth;
    }

}