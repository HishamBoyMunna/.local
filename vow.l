flex prog1.l
gcc lex.yy.c -o prog1
./prog1

%{
#include <stdio.h>
int vowels = 0;
int consonants = 0;
%}

%%
[aeiouAEIOU]   { vowels++; }
[a-zA-Z]       { consonants++; }
\n             { /* Ignore newlines */ }
.              { /* Ignore spaces, digits, and special characters */ }
%%

int yywrap() {
    return 1;
}

int main() {
    printf("Enter text (Press Ctrl+D on Linux / Ctrl+Z on Windows to finish):\n");
    yylex();
    printf("\nTotal Vowels: %d\n", vowels);
    printf("Total Consonants: %d\n", consonants);
    return 0;
}
