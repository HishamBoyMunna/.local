
/*
 * ============================================================================
 * SIMPLE SHIFT-REDUCE PARSER IN C
 * ============================================================================
 * GRAMMAR IMPLEMENTED:
 *    E -> E + E
 *    E -> E * E
 *    E -> ( E )
 *    E -> a          (Single character 'a' represents an identifier/operand)
 *
 * HOW TO COMPILE AND RUN:
 *    1. Compile with GCC:
 *       gcc -Wall -Wextra srp.c -o srp
 *
 *    2. Run the executable:
 *       ./srp
 *
 * SAMPLE INPUTS TO TEST:
 *    Valid:   a+a*a     or   (a+a)*a
 *    Invalid: a+*a      or   (a+a
 * ============================================================================
 */

#include <stdio.h>
#include <string.h>

char input[100];
char stack[100];
int top = -1;       // Stack top index
int i = 0;          // Input string current index

// Helper function to print the current parsing step
void printStep(const char* action) {
    printf("$%-14s | %-14s$ | %s\n", stack, input + i, action);
}

// Check the top of the stack and reduce if it matches any production rule
void checkAndReduce() {
    int reduced;
    do {
        reduced = 0;

        // Rule 1: E -> a (If 'a' is on top of the stack, reduce it to 'E')
        if (top >= 0 && stack[top] == 'a') {
            stack[top] = 'E';
            printStep("REDUCE E -> a");
            reduced = 1;
        }
        // Rule 2: E -> E + E
        else if (top >= 2 && strcmp(&stack[top - 2], "E+E") == 0) {
            stack[top - 2] = 'E';
            stack[top - 1] = '\0';
            top -= 2;
            printStep("REDUCE E -> E+E");
            reduced = 1;
        }
        // Rule 3: E -> E * E
        else if (top >= 2 && strcmp(&stack[top - 2], "E*E") == 0) {
            stack[top - 2] = 'E';
            stack[top - 1] = '\0';
            top -= 2;
            printStep("REDUCE E -> E*E");
            reduced = 1;
        }
        // Rule 4: E -> ( E )
        else if (top >= 2 && strcmp(&stack[top - 2], "(E)") == 0) {
            stack[top - 2] = 'E';
            stack[top - 1] = '\0';
            top -= 2;
            printStep("REDUCE E -> (E)");
            reduced = 1;
        }
    } while (reduced); // Keep reducing as long as the stack top matches a rule
}

int main() {
    printf("Grammar Rules:\n");
    printf("  E -> E+E | E*E | (E) | a\n\n");
    printf("Enter the input string (e.g., a+a*a): ");
    if (scanf("%99s", input) != 1) {
        return 1;
    }

    int len = strlen(input);
    stack[0] = '\0';

    printf("\n%-15s | %-15s | %s\n", "STACK", "INPUT", "ACTION");
    printf("----------------------------------------------------\n");

    // Loop through each character of the input string
    while (i < len) {
        // 1. SHIFT: Push the current input character onto the stack
        top++;
        stack[top] = input[i];
        stack[top + 1] = '\0';
        i++; // Advance input pointer

        printStep("SHIFT");

        // 2. REDUCE: Try to reduce the top of the stack using grammar rules
        checkAndReduce();
    }

    printf("----------------------------------------------------\n");

    // Final Check: Stack must contain ONLY the starting symbol 'E'
    if (strcmp(stack, "E") == 0) {
        printf("Result: String ACCEPTED!\n");
    } else {
        printf("Result: String REJECTED (Syntax Error)!\n");
    }

    return 0;
}
