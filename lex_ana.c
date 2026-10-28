//gcc -Wall -Wextra lexer.c -o lexer
//./lexer

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>

// Check if a character is a delimiter/punctuation
bool isDelimiter(char ch) {
    return (ch == ' ' || ch == '\t' || ch == '\n' || 
            ch == '+' || ch == '-' || ch == '*' || 
            ch == '/' || ch == ',' || ch == ';' || ch == '>' || 
            ch == '<' || ch == '=' || ch == '(' || ch == ')' || 
            ch == '[' || ch == ']' || ch == '{' || ch == '}');
}

// Check if a character is an arithmetic or relational operator
bool isOperator(char ch) {
    return (ch == '+' || ch == '-' || ch == '*' || 
            ch == '/' || ch == '>' || ch == '<' || ch == '=');
}

// Check if a string is a reserved C keyword
bool isKeyword(const char* str) {
    const char* keywords[] = {
        "if", "else", "while", "do", "break", "continue", 
        "int", "double", "float", "return", "char", "void"
    };
    int numKeywords = sizeof(keywords) / sizeof(keywords[0]);
    
    for (int i = 0; i < numKeywords; i++) {
        if (strcmp(str, keywords[i]) == 0) {
            return true;
        }
    }
    return false;
}

// Check if a string is a valid integer
bool isInteger(const char* str) {
    int len = strlen(str);
    if (len == 0) return false;
    
    for (int i = 0; i < len; i++) {
        if (!isdigit((unsigned char)str[i])) {
            return false;
        }
    }
    return true;
}

// Check if a string is a valid C identifier
bool isValidIdentifier(const char* str) {
    if (!isalpha((unsigned char)str[0]) && str[0] != '_') {
        return false;
    }
    for (int i = 1; str[i] != '\0'; i++) {
        if (!isalnum((unsigned char)str[i]) && str[i] != '_') {
            return false;
        }
    }
    return true;
}

// Extract a substring from 'left' to 'right'
void extractSubstring(const char* str, char* subStr, int left, int right) {
    int len = right - left + 1;
    strncpy(subStr, str + left, len);
    subStr[len] = '\0';
}

// Main lexical analysis routine
void lexicalAnalyze(const char* str) {
    int left = 0, right = 0;
    int len = strlen(str);
    char subStr[100];

    printf("%-15s | %s\n", "LEXEME", "TOKEN TYPE");
    printf("-----------------------------------\n");

    while (right <= len && left <= right) {
        if (str[right] != '\0' && !isDelimiter(str[right])) {
            right++;
        }

        if (str[right] == '\0' || isDelimiter(str[right])) {
            if (left == right) {
                if (isOperator(str[right])) {
                    printf("%-15c | Operator\n", str[right]);
                } else if (!isspace((unsigned char)str[right]) && str[right] != '\0') {
                    printf("%-15c | Punctuation / Delimiter\n", str[right]);
                }
                right++;
                left = right;
            } else {
                extractSubstring(str, subStr, left, right - 1);

                if (isKeyword(subStr)) {
                    printf("%-15s | Keyword\n", subStr);
                } else if (isInteger(subStr)) {
                    printf("%-15s | Integer Constant\n", subStr);
                } else if (isValidIdentifier(subStr)) {
                    printf("%-15s | Valid Identifier\n", subStr);
                } else {
                    printf("%-15s | Invalid Token\n", subStr);
                }
                left = right;
            }
        }
    }
}

int main() {
    char sourceCode[256];
    const char* defaultCode = "int count = total + 100;";

    printf("Enter C code to analyze (or press Enter for default): ");
    
    // Read input line from user
    if (fgets(sourceCode, sizeof(sourceCode), stdin) != NULL) {
        // Strip the trailing newline character (\n) added by fgets
        sourceCode[strcspn(sourceCode, "\r\n")] = '\0';
    } else {
        sourceCode[0] = '\0'; // Handle EOF
    }

    // Check if the user entered an empty string or only spaces
    bool isEmpty = true;
    for (int i = 0; sourceCode[i] != '\0'; i++) {
        if (!isspace((unsigned char)sourceCode[i])) {
            isEmpty = false;
            break;
        }
    }

    // Fall back to default if empty
    if (isEmpty) {
        strcpy(sourceCode, defaultCode);
        printf("No input provided. Using default code.\n");
    }
    
    printf("\nSource Code: \"%s\"\n\n", sourceCode);
    lexicalAnalyze(sourceCode);
    
    return 0;
}
