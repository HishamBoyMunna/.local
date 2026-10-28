%{
#include <stdio.h>
#include <stdlib.h>
%}

%%
[0-9]+  {
            int num = atoi(yytext);
            int isPrime = 1;

            if (num <= 1) {
                isPrime = 0;
            } else {
                for (int i = 2; i * i <= num; i++) {
                    if (num % i == 0) {
                        isPrime = 0;
                        break;
                    }
                }
            }

            if (isPrime)
                printf("%d is a PRIME number.\n", num);
            else
                printf("%d is NOT a prime number.\n", num);
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
