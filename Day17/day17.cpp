
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <regex>
#include <vector>

class TargetOperator {
    public:
        TargetOperator(std::vector<int> ranges) {

            // Optamised for part 1
            // for (int i = findMinX(ranges[0]); i <= ranges[1] - 1; i++) {
            //     this->xRange.push_back(i);
            // }
            for (int i = 0; i <= ranges[1]; i++) {
                this->xRange.push_back(i);
            }
            
            // Optamised for part 1
            // for (int i = 0; i <= (-ranges[2]); i++) {
            //     this->yRange.push_back(i);
            // }
            for (int i = ranges[2]; i <= (-ranges[2]); i++) {
                this->yRange.push_back(i);
            }

            this->minX = ranges[0];
            this->maxX = ranges[1];
            this->minY = ranges[3];
            this->maxY = ranges[2];
            
        };

        int calculatePartOne() {
            int currentMaxY = 0;
            for (auto x = xRange.begin(); x != xRange.end(); ++x) {
                for (auto y = yRange.begin(); y != yRange.end(); ++y) {
                    int currentHeight = this->simulate((*x), (*y));
                    if (currentHeight > currentMaxY) {
                        currentMaxY = currentHeight;
                    }
                }
            }
            return currentMaxY;
        };

        int calculatePartTwo() {
            int sum = 0;
            for (auto x = xRange.begin(); x != xRange.end(); ++x) {
                for (auto y = yRange.begin(); y != yRange.end(); ++y) {
                    int currentHeight = this->simulate((*x), (*y));
                    if (currentHeight != -1) {
                        sum++;
                    }
                }
            }
            return sum;
        };

    private:
        int minX;
        int maxX;
        int minY;
        int maxY;
        std::vector<int> xRange;
        std::vector<int> yRange;

        int simulate(int startVx, int startVy) {

            int currentX = 0;
            int currentY = 0;
            int currentVx = startVx;
            int currentVy = startVy;
            int currentMaxY = 0;
            while ((currentX < maxX) && (currentY > maxY)) {
                currentX += currentVx;
                currentY += currentVy;
                if (currentY > currentMaxY) {
                    currentMaxY = currentY;
                }
                if (currentVx != 0) {
                    currentVx--;
                }
                currentVy--;
                if (minX <= currentX && maxX >= currentX && minY >= currentY && maxY <= currentY) {
                    return currentMaxY;
                }
            }

            return -1;

        };

        int findMinX(int targetMinX) {
            int fact = 1;
            int num = 1;
            while (true) {
                if (fact > targetMinX) {
                    return num;
                }
                num++;
                fact += num;
            };
        }
        
};

void partOne() {

    std::cout << "Part One" << std::endl;

    std::ifstream infile("input.txt");
    std::string line;
    std::vector<int> target;

    while (std::getline(infile, line)) {

        const std::regex r("target area: x=([0-9]+)..([0-9]+), y=(-[0-9]+)..(-[0-9]+)");
        std::smatch sm;

        if (std::regex_search(line, sm, r))
        {
            for (int i=1; i<sm.size(); i++)
            {
                std::string myString = sm[i].str();

                target.push_back(std::stoi(myString));
            }
        }

    }

    TargetOperator* to = new TargetOperator(target);

    std::cout << "Max Height: " << to->calculatePartOne() << std::endl;

    std::cout << "Distinct Values: " << to->calculatePartTwo() << std::endl;

    return;
};

int main()
{
    partOne();
    return 0;
};