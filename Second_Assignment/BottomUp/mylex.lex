%{
#include "grammar.tab.h" 
#include <string.h>

extern int atoi(const char*);
extern double atof(const char*);
%}

%option noyywrap

%%

"<courses>"              { strcpy(yylval.lexeme, yytext); return COURSES; }

[0-9]{5}                 { strcpy(yylval.lexeme, yytext); return NUM; }

\".*\"                  { strcpy(yylval.lexeme, yytext); return NAME; }

[0-5](\.[0-9]?[0-9])?|6        { yylval.credits = atof(yytext); strcpy(yylval.lexeme, yytext); return CREDITS; }

[B|M]\.Sc\.        { strcpy(yylval.lexeme, yytext); return DEGREE; }

Software|Electrical|Mechanical|Management|Biomedical { strcpy(yylval.lexeme, yytext); return SCHOOL; }

[e|E]lective              { strcpy(yylval.lexeme, yytext); return ELECTIVE; }

\n                       ; /* Skip newlines */

[ \t]                    ; /* Skip spaces and tabs */

.                        { fprintf(stderr, "Unrecognized token %c\n", yytext[0]); }

%%
