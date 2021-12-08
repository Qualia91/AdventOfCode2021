#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#define CHUNK 65536
#define newLineChar "\r\n"
#define sepChar "|"
#define spaceChar " "

typedef struct return_struct {
    int counter;
    int sum;
} return_struct_type;

typedef struct letters {
    char zero[7];
    char one[3];
    char two[6];
    char three[6];
    char four[5];
    char five[6];
    char six[7];
    char seven[4];
    char eight[8];
    char nine[7];

    char lengthFive[3][6];
    char lengthSix[3][7];

    char a;
    char b;
    char c;
    char d;
    char e;
    char f;
    char g;
} letters_type;

char* getNextSplit(char* inStr, char* splitCharacter) {
    return strtok(inStr, splitCharacter);
}

int checkTokenPartOne(char* token) {
    int currentTokenLength = strlen(token);
    if (currentTokenLength == 2 || currentTokenLength == 3 || currentTokenLength == 4 || currentTokenLength == 7) {
        return 1;
    }
    return 0;
}

bool compareStrings(char* a, char* b, int length) {
    for (int index = 0; index < length; ++index) {
        if (strchr(b, a[index]) == NULL) {
            return false;
        }
    }
    return true;
}

// first check length of strings. if they are the same, iterate over one and check that character is in next
int checkTokenPartTwo(char* token, letters_type letters) {
    int currentTokenLength = strlen(token);
    if (currentTokenLength == 2) {
        return 1;
    }
    if (currentTokenLength == 3) {
        return 7;
    }
    if (currentTokenLength == 4) {
        return 4;
    }
    if (currentTokenLength == 5) {
        // check all length fives
        if (compareStrings(token, letters.two, 5)) {
            return 2;
        }
        if (compareStrings(token, letters.three, 5)) {
            return 3;
        }
        if (compareStrings(token, letters.five, 5)) {
            return 5;
        }
    }
    if (currentTokenLength == 6) {
        // check all length sixes
        if (compareStrings(token, letters.zero, 6)) {
            return 0;
        }
        if (compareStrings(token, letters.six, 6)) {
            return 6;
        }
        if (compareStrings(token, letters.nine, 6)) {
            return 9;
        }
    }
    if (currentTokenLength == 7) {
        return 8;
    }
    return 0;
}

// Create six
letters_type createSix(letters_type letters) {

    letters.six[0] = letters.a;
    letters.six[1] = letters.b;
    letters.six[2] = letters.d;
    letters.six[3] = letters.f;
    letters.six[4] = letters.e;
    letters.six[5] = letters.g;

    return letters;
}

// Create five
letters_type createFive(letters_type letters) {

    letters.five[0] = letters.a;
    letters.five[1] = letters.b;
    letters.five[2] = letters.d;
    letters.five[3] = letters.f;
    letters.five[4] = letters.g;

    return letters;
}

// Create zero
letters_type createZero(letters_type letters) {

    letters.zero[0] = letters.a;
    letters.zero[1] = letters.c;
    letters.zero[2] = letters.f;
    letters.zero[3] = letters.g;
    letters.zero[4] = letters.e;
    letters.zero[5] = letters.b;

    return letters;
}

// Find b using the value we do not know in 4
letters_type findB(letters_type letters) {

    for (int index = 0; index < 5; ++index) {
        if (!(
            (letters.four[index] == letters.c) ||
            (letters.four[index] == letters.d) ||
            (letters.four[index] == letters.f))) {
            letters.b = letters.four[index];
            return letters;
        }
    }

    return letters;
}

// Find f using the value from 1 that isnt c
letters_type findF(letters_type letters) {

    for (int index = 0; index < 6; ++index) {
        if (letters.one[index] != letters.c) {
            letters.f = letters.one[index];
            return letters;
        }
    }

    return letters;
}

// Create three with the letters we have and 1
letters_type createThree(letters_type letters) {

    memcpy(letters.three, letters.one, 2);
    letters.three[2] = letters.a;
    letters.three[3] = letters.d;
    letters.three[4] = letters.g;

    return letters;
}

// Now we have a,c,g and e, the other letter in 2 is d
letters_type findD(letters_type letters) {

    for (int index = 0; index < 6; ++index) {
        if (!(
                (letters.two[index] == letters.a) || 
                (letters.two[index] == letters.c) || 
                (letters.two[index] == letters.e) || 
                (letters.two[index] == letters.g))) {
            letters.d = letters.two[index];
            return letters;
        }
    }

    return letters;
}

// One of the five group has the letter e, this is 2
letters_type findTwo(letters_type letters) {

    for (int index = 0; index < 3; ++index) {
        if (strchr(letters.lengthFive[index], letters.e) != NULL) {
            memcpy(letters.two, letters.lengthFive[index], 5);
            return letters;
        }
    }

    return letters;
}

letters_type findEFromMissingInNine(letters_type letters) {

    for (int letterIndex = 0; letterIndex < 7; ++letterIndex) {
        if (strchr(letters.nine, letters.eight[letterIndex]) == NULL) {
            letters.e = letters.eight[letterIndex];
            return letters;
        }
    }

    return letters;
}

letters_type createNine(letters_type letters) {

    memcpy(letters.nine, letters.four, 4);
    letters.nine[4] = letters.a;
    letters.nine[5] = letters.g;

    return letters;
}

letters_type findGInFiveGroup(letters_type letters) {

    // 3 letters are repeated in every val in 5 group.
    // One of these values is not 4 and is not a. This is G

    // iterate over letters in first 5 group
    for (int letterIndex = 0; letterIndex < 5; ++letterIndex) {
        for (int lengthGroupIndex = 1; lengthGroupIndex < 3; ++lengthGroupIndex) {

            // check the letter in the first 5 is in the rest
            if (strchr(letters.lengthFive[lengthGroupIndex], letters.lengthFive[0][letterIndex]) != NULL && 
                    strchr(letters.lengthFive[lengthGroupIndex], letters.lengthFive[0][letterIndex]) != NULL) {
                
                // If it is, check its not a
                if (letters.lengthFive[0][letterIndex] != letters.a) {

                    // Now check that this letter isnt in 4
                    if (strchr(letters.four, letters.lengthFive[0][letterIndex]) == NULL) {
                        letters.g = letters.lengthFive[0][letterIndex];
                        return letters;
                    }
                }
            }
        }
    }
    return letters;
}

letters_type findCInSixGroup(letters_type letters) {

    // One of the letters with length 6 doesn't have one of the letters in 1. This is c
    for (int lengthSixGroupIndex = 0; lengthSixGroupIndex < 3; ++lengthSixGroupIndex) {

        // iterate over letters in 1
        for (int oneLetterIndex = 0; oneLetterIndex < 2; ++oneLetterIndex) {

            // check that this letter in 1 is in 6
            if (strchr(letters.lengthSix[lengthSixGroupIndex], letters.one[oneLetterIndex]) == NULL) {
                letters.c = letters.one[oneLetterIndex];
                return letters;
            }
        }
    }
    return letters;
}

letters_type findA(letters_type letters) {

    // iterate over characters in 7 and check what isn't in 1. This is a
    for (int i = 0; i < 3; ++i) {
        if (strchr(letters.one, letters.seven[i]) == NULL) {
            letters.a = letters.seven[i];
            break;
        }
    }

    return letters;
}

return_struct_type workOnLine(char* buf) {
    int counter = 0;
    int sum = 0;
    char* token = getNextSplit(buf, spaceChar);
    while (token != NULL)
    {

        int lengthFiveFound = 0;
        int lengthSixFound = 0;

        letters_type letters = {0};

        for (int index = 0; index < 10; ++index) {
            int currentTokenLength = strlen(token);
            if (currentTokenLength == 2) {
                memcpy(letters.one, token, 2);
            } else if (currentTokenLength == 3) {
                memcpy(letters.seven, token, 3);
            } else if (currentTokenLength == 4) {
                memcpy(letters.four, token, 4);
            } else if (currentTokenLength == 5) {
                memcpy(letters.lengthFive[lengthFiveFound], token, 5);
                lengthFiveFound++;
            } else if (currentTokenLength == 6) {
                memcpy(letters.lengthSix[lengthSixFound], token, 6);
                lengthSixFound++;
            } else if (currentTokenLength == 7) {
                memcpy(letters.eight, token, 7);
            } else {
                printf("Too many letters");
            }
            token = getNextSplit(NULL, spaceChar);
        }

        letters = findA(letters);
        letters = findCInSixGroup(letters);
        letters = findGInFiveGroup(letters);
        letters = createNine(letters);
        letters = findEFromMissingInNine(letters);
        letters = findTwo(letters);
        letters = findD(letters);
        letters = createThree(letters);
        letters = findF(letters);
        letters = findB(letters);
        letters = createSix(letters);
        letters = createFive(letters);
        letters = createZero(letters);
    
        // printf( "0 : %s\n", letters.zero);
        // printf( "1 : %s\n", letters.one);
        // printf( "2 : %s\n", letters.two);
        // printf( "3 : %s\n", letters.three);
        // printf( "4 : %s\n", letters.four);
        // printf( "5 : %s\n", letters.five);
        // printf( "6 : %s\n", letters.six);
        // printf( "7 : %s\n", letters.seven);
        // printf( "8 : %s\n", letters.eight);
        // printf( "9 : %s\n", letters.nine);
        // printf( "l5 : %s\n", letters.lengthFive);
        // printf( "l6 : %s\n", letters.lengthSix);
        // printf( "a : %c\n", letters.a);
        // printf( "b : %c\n", letters.b);
        // printf( "c : %c\n", letters.c);
        // printf( "d : %c\n", letters.d);
        // printf( "e : %c\n", letters.e);
        // printf( "f : %c\n", letters.f);
        // printf( "g : %c\n", letters.g);

        token = getNextSplit(NULL, spaceChar);
        counter += checkTokenPartOne(token);
        sum += (1000 * checkTokenPartTwo(token, letters));

        token = getNextSplit(NULL, spaceChar);
        counter += checkTokenPartOne(token);
        sum += (100 * checkTokenPartTwo(token, letters));

        token = getNextSplit(NULL, spaceChar);
        counter += checkTokenPartOne(token);
        sum += (10 * checkTokenPartTwo(token, letters));

        token = getNextSplit(NULL, newLineChar);
        counter += checkTokenPartOne(token);
        sum += checkTokenPartTwo(token, letters);

        token = getNextSplit(NULL, spaceChar);

    }

    // printf("Next %d\n", sum);

    return_struct_type return_struct = {counter, sum};
    return return_struct;
}

void main(void) {

    char buf[CHUNK];
    FILE *file;
    size_t nread;

    int counter = 0;
    int sum = 0;
    
    file = fopen("input.txt", "r");
    if (file) {
        while (fgets(buf, sizeof buf, file)) {  
            return_struct_type return_struct = workOnLine(buf);
            counter += return_struct.counter;
            sum += return_struct.sum;
        }
        if (ferror(file)) {
            printf("On no! We has yksi error :(");
            return;
        }
        fclose(file);
    }

    printf("Part One: %d\n", counter);
    printf("Part Two: %d\n", sum);
}  