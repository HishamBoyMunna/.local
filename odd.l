%{
#include <stdio.h>
#include <stdlib.h>
%}

%%
[0-9]+  {
            int num = atoi(yytext);
            if (num % 2 == 0)
                printf("%d is an EVEN number.\n", num);
            else
                printf("%d is an ODD number.\n", num);
        }
\n      { printf("\nEnter another number (or Ctrl+C to exit): "); }
.       { /* Ignore non-digits */ }
%%

int yywrap() {
    return 1;
}

int main() {
    printf("Enter a number: ");
    yylex();
    return 0;
}
