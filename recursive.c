/*
 * ============================================================================
 * SIMPLE RECURSIVE DESCENT PARSER IN C
 * ============================================================================
 * GRAMMAR IMPLEMENTED (After Eliminating Left Recursion):
 *    E  -> T E'
 *    E' -> + T E' | epsilon
 *    T  -> F T'
 *    T' -> * F T' | epsilon
 *    F  -> ( E )  | id       (Note: Any letter/digit like 'a', 'b', '5' is id)
 *
 * HOW TO COMPILE AND RUN:
 *    1. Compile with GCC:
 *       gcc -Wall -Wextra rdp.c -o rdp
 *
 *    2. Run the executable:
 *       ./rdp
 *
 * SAMPLE INPUTS TO TEST:
 *    Valid:   a+b*c     or   (a+b)*c
 *    Invalid: a+*b      or   (a+b
 * ============================================================================
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

char input[100];
int i = 0;      // Current index in the input string
int error = 0;  // Flag: 0 = Valid so far, 1 = Syntax Error

// Function prototypes for each non-terminal in the grammar
void E();
void Eprime();
void T();
void Tprime();
void F();

int main() {
    printf("Enter an arithmetic expression (e.g., a+b*c): ");
    if (scanf("%99s", input) != 1) {
        return 1;
    }

    // Start parsing from the starting symbol E
    E();

    // Input is valid ONLY if the entire string was consumed and no error occurred
    if (strlen(input) == (size_t)i && error == 0) {
        printf("\nResult: String \"%s\" is ACCEPTED (Valid Syntax)!\n", input);
    } else {
        printf("\nResult: String \"%s\" is REJECTED (Syntax Error)!\n", input);
    }

    return 0;
}

// Rule: E -> T E'
void E() {
    T();
    Eprime();
}

// Rule: E' -> + T E' | epsilon
void Eprime() {
    if (input[i] == '+') {
        i++;        // Match '+'
        T();
        Eprime();
    }
    // Else: do nothing (matches epsilon / empty production)
}

// Rule: T -> F T'
void T() {
    F();
    Tprime();
}

// Rule: T' -> * F T' | epsilon
void Tprime() {
    if (input[i] == '*') {
        i++;        // Match '*'
        F();
        Tprime();
    }
    // Else: do nothing (matches epsilon / empty production)
}

// Rule: F -> ( E ) | id
void F() {
    if (isalnum((unsigned char)input[i])) {
        i++;        // Match identifier/number (e.g., a, b, 1, 2)
    } else if (input[i] == '(') {
        i++;        // Match '('
        E();
        if (input[i] == ')') {
            i++;    // Match ')'
        } else {
            error = 1; // Missing closing parenthesis ')'
        }
    } else {
        error = 1;     // Unexpected character
    }
}
