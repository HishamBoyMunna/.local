%{
#include <stdio.h>
#include <stdlib.h>
%}

%%
[0-9]+  {
            int num = atoi(yytext);
            int original = num;
            int sum = 0;
            int digits = yyleng; // Number of digits in the matched string

            while (num > 0) {
                int rem = num % 10;
                
                // Calculate rem^digits using integer multiplication
                int power = 1;
                for (int i = 0; i < digits; i++) {
                    power *= rem;
                }
                
                sum += power;
                num /= 10;
            }

            if (sum == original)
                printf("%d is an ARMSTRONG number.\n", original);
            else
                printf("%d is NOT an Armstrong number.\n", original);
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
