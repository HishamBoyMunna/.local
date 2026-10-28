%{
#include <stdio.h>
int token_count = 0;
%}

/* Regular Expression Definitions */
DIGIT       [0-9]
LETTER      [a-zA-Z_]
ID          {LETTER}({LETTER}|{DIGIT})*
INT_CONST   {DIGIT}+
FLOAT_CONST {DIGIT}+"."{DIGIT}+

%%

"#".*                                                 { printf("%-15s | Preprocessor Directive\n", yytext); token_count++; }
"int"|"float"|"char"|"double"|"void"|"if"|"else"|"while"|"for"|"return"|"break"|"continue" {
                                                        printf("%-15s | Keyword\n", yytext);
                                                        token_count++;
                                                      }
{ID}                                                  { printf("%-15s | Identifier\n", yytext); token_count++; }
{FLOAT_CONST}                                         { printf("%-15s | Float Constant\n", yytext); token_count++; }
{INT_CONST}                                           { printf("%-15s | Integer Constant\n", yytext); token_count++; }
"=="|"!="|"<="|">="|"<"|">"                           { printf("%-15s | Relational Operator\n", yytext); token_count++; }
"+"|"-"|"*"|"/"|"="|"%"                               { printf("%-15s | Arithmetic/Assign Operator\n", yytext); token_count++; }
"&&"|"||"|"!"                                         { printf("%-15s | Logical Operator\n", yytext); token_count++; }
";"|","|"("|")"|"{"|"}"|"["|"]"                       { printf("%-15s | Punctuation / Delimiter\n", yytext); token_count++; }
\"[^\"\n]*\"                                          { printf("%-15s | String Literal\n", yytext); token_count++; }
"//".*                                                { /* Ignore single-line comments */ }
"/*"([^*]|\*+[^*/])*\*+"/"                            { /* Ignore multi-line comments */ }
[ \t\n]+                                              { /* Ignore whitespace, tabs, and newlines */ }
.                                                     { printf("%-15s | Invalid / Unrecognized Token\n", yytext); }

%%

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    // If a file is passed as an argument, read from that file
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            printf("Error: Could not open file %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    } else {
        printf("Enter C code (Press Ctrl+D on Linux / Ctrl+Z on Windows to finish):\n\n");
    }

    printf("%-15s | %s\n", "LEXEME", "TOKEN TYPE");
    printf("--------------------------------------------\n");
    
    yylex(); // Start lexical analysis
    
    printf("--------------------------------------------\n");
    printf("Total Tokens Identified: %d\n", token_count);
    
    return 0;
}

//flex lexer.l
//gcc -Wall -Wextra lex.yy.c -o lexer
//
