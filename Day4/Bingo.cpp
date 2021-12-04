
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <regex>
#include <vector>

class BingoBoard {
    public:
        BingoBoard(int boardId) {
            this->boardId = boardId; 
        };

        int getId() {
            return this->boardId;
        }

        void addLine(std::string inputLine) {

            const std::regex r("\\s*([0-9]+)\\s*([0-9]+)\\s*([0-9]+)\\s*([0-9]+)\\s*([0-9]+)\\s*");
            std::smatch sm;

            if (std::regex_search(inputLine, sm, r))
            {
                std::vector<int> row;
                std::vector<bool> rowSelections;
                for (int i=1; i<sm.size(); i++)
                {
                    std::string myString = sm[i].str();

                    row.push_back(std::stoi(myString));
                    rowSelections.push_back(false);
                }
                board.push_back(row);
                selections.push_back(rowSelections);
            }
            currentRow+=1;
        };

        std::vector<std::vector<int>> getBoard() {
            return board;
        };

        bool check(int checkNumber) {
            bool found = false;
            for (auto row = board.begin(); row != board.end(); ++row) {
                for (auto val = (*row).begin(); val != (*row).end(); ++val) {
                    if (checkNumber == (*val)) {
                        int rowIndex = std::distance(board.begin(), row);
                        int colIndex = std::distance((*row).begin(), val);
                        selections[rowIndex][colIndex] = true;
                        found = true;
                    }
                }
            }

            // Check if we have won
            if (found) {
                return hasWon();
            };

            return false;
        };

        int getSumOfUnselected() {
            int sum = 0;
            for (auto row = selections.begin(); row != selections.end(); ++row) {
                for (auto val = (*row).begin(); val != (*row).end(); ++val) {
                    if (!(*val)) {
                        int rowIndex = std::distance(selections.begin(), row);
                        int colIndex = std::distance((*row).begin(), val);
                        sum += board[rowIndex][colIndex];
                    }
                }
            }
            return sum;
        }

    private:
        std::vector<std::vector<int>> board;
        std::vector<std::vector<bool>> selections;
        int currentRow = 0;
        int boardId;
        int hasWonAlready = false;

        bool hasWon() {
            if (hasWonAlready) {
                return false;
            }
            for (auto row = selections.begin(); row != selections.end(); ++row) {
                if (checkRow((*row))) {
                    this->hasWonAlready = true;
                    return true;
                }
                for (int i = 0; i < 5; i++) {
                    if (checkCol(i)) {
                        this->hasWonAlready = true;
                        return true;
                    }
                }
            }
            return false;
        };

        bool checkRow(std::vector<bool> row) {
            for (auto val = row.begin(); val != row.end(); ++val) {
                if (!(*val)) {
                    return false;
                }
            }
            return true;
        };

        bool checkCol(int colIndex) {
            for (auto row = selections.begin(); row != selections.end(); ++row) {
                if (!((*row)[colIndex])) {
                    return false;
                }
            }
            return true;
        };
};

void partTwo() {

    std::cout << "Part Two" << std::endl;

    std::ifstream infile("input.txt");

    std::string line;
    std::string firstLine;
    bool firstLineRead = false;

    std::vector<BingoBoard *> bingoBoards;
    int boardIndex = -1;

    while (std::getline(infile, line)) {

        if (!firstLineRead) {
            firstLine = line;
            firstLineRead = true;
        } else {

            // Check if line is empty
            if (line.empty()) {
                boardIndex += 1;
                bingoBoards.push_back(new BingoBoard(boardIndex));
            } else {

                bingoBoards[boardIndex]->addLine(line);

            }

        }

    }

    std::stringstream ss(firstLine);

    int lastToWinIndex = -1;
    int lastToWinNumber = -1;
    int amountWon = 0;
    for (int i; ss >> i;) {

        for (auto bingoBoard = bingoBoards.begin(); bingoBoard != bingoBoards.end(); ++bingoBoard) {
            if ((*bingoBoard)->check(i)) {
                int winningIndex = std::distance(bingoBoards.begin(), bingoBoard);
                lastToWinIndex = winningIndex;
                lastToWinNumber = i;
                amountWon++;
                if (amountWon == bingoBoards.size()) {
                    break; 
                }
            }
        }

        if (amountWon == bingoBoards.size()) {
            break;
        }

        if (ss.peek() == ',') {
            ss.ignore();
        }
    }

    auto lastWinning = bingoBoards[lastToWinIndex];

    int sum = lastWinning->getSumOfUnselected();
    int score = sum * lastToWinNumber;

    std::cout << "Winning score of last board to win: " << score << std::endl;

    return;
};

void partOne() {

    std::cout << "Part One" << std::endl;

    std::ifstream infile("input.txt");

    std::string line;
    std::string firstLine;
    bool firstLineRead = false;

    std::vector<BingoBoard *> bingoBoards;
    int boardIndex = -1;

    while (std::getline(infile, line)) {

        if (!firstLineRead) {
            firstLine = line;
            firstLineRead = true;
        } else {

            // Check if line is empty
            if (line.empty()) {
                boardIndex += 1;
                bingoBoards.push_back(new BingoBoard(boardIndex));
            } else {

                bingoBoards[boardIndex]->addLine(line);

            }

        }

    }

    std::stringstream ss(firstLine);

    for (int i; ss >> i;) {

        for (auto bingoBoard = bingoBoards.begin(); bingoBoard != bingoBoards.end(); ++bingoBoard) {
            if ((*bingoBoard)->check(i)) {
                int sum = (*bingoBoard)->getSumOfUnselected();
                std::cout << "sum " << sum << std::endl;
                int result = sum * i;
                std::cout << "Board " << (*bingoBoard)->getId() << " has won with score of " << result << std::endl;
                return;
            }
        }

        if (ss.peek() == ',') {
            ss.ignore();
        }
    }

    return;
};

int main()
{
    partOne();
    partTwo();
    return 0;
};