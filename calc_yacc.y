/*
 * ============================================================================
 * SIMPLE CALCULATOR USING YACC (STANDALONE SINGLE FILE)
 * ============================================================================
 * HOW TO COMPILE AND RUN:
 * 
 * 1. Generate C parser code using YACC (or Bison):
 *    yacc -d calc.y
 *    (Alternatively: bison -d -y calc.y)
 * 
 * 2. Compile the generated y.tab.c file with GCC:
 *    gcc -Wall -Wextra y.tab.c -o calc
 * 
 * 3. Run the calculator:
 *    ./calc
 * 
 * SAMPLE RUN:
 *    Enter an arithmetic expression: (10 + 20) * 3 - 5
 *    Result = 85
 * ============================================================================
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int yylex(void);
void yyerror(const char *s);
%}

/* Token declaration */
%token NUMBER

/* Operator Precedence and Associativity (Lowest to Highest) */
%left '+' '-'
%left '*' '/' '%'
%right UMINUS  /* Unary minus (e.g., -5) has highest precedence */

%%

/* Grammar Rules */
line:
    expr '\n'           { printf("Result = %d\n", $1); exit(0); }
    ;

expr:
    expr '+' expr       { $$ = $1 + $3; }
    | expr '-' expr     { $$ = $1 - $3; }
    | expr '*' expr     { $$ = $1 * $3; }
    | expr '/' expr     { 
                            if ($3 == 0) {
                                yyerror("Division by zero!");
                                exit(1);
                            }
                            $$ = $1 / $3; 
                        }
    | expr '%' expr     { 
                            if ($3 == 0) {
                                yyerror("Modulo by zero!");
                                exit(1);
                            }
                            $$ = $1 % $3; 
                        }
    | '-' expr %prec UMINUS { $$ = -$2; }
    | '(' expr ')'      { $$ = $2; }
    | NUMBER            { $$ = $1; }
    ;

%%

/* Built-in Lexical Analyzer (Reads numbers and operators directly) */
int yylex(void) {
    int c;

    /* Skip spaces and tabs */
    while ((c = getchar()) == ' ' || c == '\t');

    /* If a digit is found, read the full integer into yylval */
    if (isdigit(c)) {
        ungetc(c, stdin);
        if (scanf("%d", &yylval) == 1) {
            return NUMBER;
        }
    }

    /* Return EOF if end of input */
    if (c == EOF) {
        return 0;
    }

    /* Return operators, parentheses, or '\n' directly by their ASCII value */
    return c;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    printf("Enter an arithmetic expression: ");
    yyparse();
    return 0;
}
