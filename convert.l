/*
 * ============================================================================
 * LEX PROGRAM TO CONVERT UPPERCASE TO LOWERCASE AND VICE VERSA
 * ============================================================================
 * HOW TO COMPILE AND RUN:
 *    1. Generate C code from the Lex file:
 *       flex case_convert.l
 *
 *    2. Compile the generated lex.yy.c with GCC:
 *       gcc -Wall -Wextra lex.yy.c -o case_convert
 *
 *    3. Run the executable:
 *       ./case_convert
 *
 * SAMPLE RUN:
 *    Enter a string: Hello World 123!
 *    hELLO wORLD 123!
 *    (Press Ctrl+D on Linux/macOS or Ctrl+Z on Windows to exit)
 * ============================================================================
 */

%{
#include <stdio.h>
%}

%%

[a-z]   { printf("%c", yytext[0] - 32); } /* Convert lowercase to uppercase */
[A-Z]   { printf("%c", yytext[0] + 32); } /* Convert uppercase to lowercase */
\n      { printf("\n"); }                 /* Preserve newlines */
.       { printf("%s", yytext); }         /* Print digits, spaces, and symbols as-is */

%%

int yywrap(void) {
    return 1;
}

int main(void) {
    printf("Enter a string (Press Ctrl+D on Linux / Ctrl+Z on Windows to stop):\n");
    yylex();
    return 0;
}
