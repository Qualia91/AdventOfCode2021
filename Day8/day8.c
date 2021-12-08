#include <stdio.h>
#include <string.h>
#define CHUNK 65536
#define newLineChar "\r\n"
#define sepChar "|"
#define spaceChar " "

char* getNextSplit(char* inStr, char* splitCharacter) {
    return strtok(inStr, splitCharacter);
}

int checkToken(char* token) {
    int currentTokenLength = strlen(token);
    if (currentTokenLength == 2 || currentTokenLength == 3 || currentTokenLength == 4 || currentTokenLength == 7) {
        return 1;
    }
    return 0;
}

int workOnLine(char* buf) {
    int counter = 0;
    char* token = getNextSplit(buf, sepChar);
    while (token != NULL)
    {
        token = getNextSplit(NULL, spaceChar);
        counter += checkToken(token);

        token = getNextSplit(NULL, spaceChar);
        counter += checkToken(token);

        token = getNextSplit(NULL, spaceChar);
        counter += checkToken(token);

        token = getNextSplit(NULL, newLineChar);
        counter += checkToken(token);

        token = getNextSplit(NULL, sepChar);
    }
    return counter;
}

void main(void) {

    char buf[CHUNK];
    FILE *file;
    size_t nread;

    int counter = 0;
    
    file = fopen("input.txt", "r");
    if (file) {
        while (fgets(buf, sizeof buf, file)) {            
            counter += workOnLine(buf);
        }
        if (ferror(file)) {
            printf("On no! We has yksi error :(");
            return;
        }
        fclose(file);
    }

    
    
    printf("%d\n", counter);
}  