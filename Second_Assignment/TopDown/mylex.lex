%{
#define NUM 300
#define NAME 301
#define CREDITS 302
#define DEGREE 303
#define SCHOOL 304
#define ELECTIVE 305
#define COURSES 306

union {
  char lexeme[100];
  double credits;
} yylval;

#include <string.h> 

extern int atoi(const char*);
extern double atof(const char*);
%}

%option noyywrap

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

int main(int argc, char** argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s input_file\n", argv[0]);
        return 1;
    }

    FILE* input_file = fopen(argv[1], "r");
    if (!input_file) {
        fprintf(stderr, "Error opening input file\n");
        return 1;
    }

    yyin = input_file;

    int token;
    printf("Token            lexeme               Semantic value\n");
    printf("----------------------------------------------------\n");
  
    while ((token = yylex())) {
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
    }

    fclose(input_file);
    return 0;
}
