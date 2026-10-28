/*
 * ============================================================================
 * YACC PARSER FOR SIMPLE CALCULATOR (calc.y)
 * ============================================================================
 * HOW TO COMPILE AND RUN:
 *    yacc -d calc.y
 *    flex calc.l
 *    gcc y.tab.c lex.yy.c -o calc
 *    ./calc
 * ============================================================================
 */

%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%token NUMBER

%left '+' '-'
%left '*' '/' '%'
%right UMINUS

%%

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
    | expr '%' expr     { $$ = $1 % $3; }
    | '-' expr %prec UMINUS { $$ = -$2; }
    | '(' expr ')'      { $$ = $2; }
    | NUMBER            { $$ = $1; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Invalid Expression: %s\n", s);
}

int main(void) {
    printf("Enter an arithmetic expression: ");
    yyparse();
    return 0;
}
