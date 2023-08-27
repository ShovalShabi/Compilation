%{
#include <string.h> 
union _lexVal lexicalValue; // semantic value of current token

extern int atoi(const char*);
extern double atof(const char*);
%}

%option noyywrap
%option yylineno
%%

"<courses>"              { strcpy(yylval.lexeme, yytext); return COURSES; }

[0-9]{5}                 { strcpy(yylval.lexeme, yytext); return NUM; }

\".*\"                  { strcpy(yylval.lexeme, yytext); return NAME; }

[0-5](\.[0-9])?|6        { yylval.credits = atof(yytext); strcpy(yylval.lexeme, yytext); return CREDITS; }

[B|M]\.Sc\.        { strcpy(yylval.lexeme, yytext); return DEGREE; }

Software|Electrical|Mechanical|Management|Biomedical { strcpy(yylval.lexeme, yytext); return SCHOOL; }

[e|E]lective              { strcpy(yylval.lexeme, yytext); return ELECTIVE; }

\n                       ; /* Skip newlines */

[ \t]                    ; /* Skip spaces and tabs */

.                        { fprintf(stderr, "Unrecognized token %c\n", yytext[0]); }

%%
/* useful for error messages */
char *token_name(enum token token)
{
    switch (token) {
        case COURSES:
            printf("COURSES          %s\n", yylval.lexeme);
            break;
        case NUM:
            printf("NUM              %s\n", yylval.lexeme);
            break;
        case NAME:
            printf("NAME             %s\n", yylval.lexeme);
            break;
        case CREDITS:
            printf("CREDITS          %s                  %.1f\n",yylval.lexeme, yylval.credits);
            break;
        case DEGREE:
            printf("DEGREE           %s\n", yylval.lexeme);
            break;
        case SCHOOL:
            printf("SCHOOL           %s\n", yylval.lexeme);
            break;
        case ELECTIVE:
            printf("ELECTIVE         %s\n", yylval.lexeme);
            break;
        default:
            fprintf(stderr, "Error: Unrecognized token\n");
            return 1;
    }
    return yylval.lexeme;
}
