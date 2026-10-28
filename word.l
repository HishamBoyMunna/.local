%{
#include <stdio.h>
int words = 0;
int chars = 0;
int lines = 0;
%}

%%
[^ \t\n]+   { words++; chars += yyleng; }
\n          { lines++; chars++; }
.           { chars++; }
%%

int yywrap() {
    return 1;
}

int main() {
    printf("Enter text (Press Ctrl+D on Linux / Ctrl+Z on Windows to finish):\n");
    yylex();
    printf("\nTotal Words: %d\n", words);
    printf("Total Characters: %d\n", chars);
    printf("Total Lines: %d\n", lines);
    return 0;
}
