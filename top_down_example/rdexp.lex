%{
#include "rdexp.h"
#include <stdlib.h>  /* for exit() */

extern int atoi (const char *);

union _lexVal lexicalValue; // semantic value of current token
%}

%option noyywrap
%option yylineno
%%

[0-9]+     { lexicalValue.ival = atoi (yytext); return NUM; }

[\n\t ]+   /* skip white space */

"+"        { lexicalValue.op = PLUS; return ADDOP;}
"-"        { lexicalValue.op = MINUS; return ADDOP;}
"*"        { lexicalValue.op = MUL; return MULOP; }
"/"        { lexicalValue.op = DIV; return MULOP;}

"^"        { return POWER; } 
"("        { return '('; }
")"        { return ')'; }

"//".*     /* skip comment */

.          { char e[100];
             sprintf(e, "unrecognized token %c", yytext[0]);  
             errorMsg(e);  
             exit(1);
           }             

%%
/* useful for error messages */
char *token_name(enum token token)
{
    switch(token) {
        case LEFT_PAR:  return "left parenthesis";
        case RIGHT_PAR: return "right parenthesis";
        case NUM:       return "number";
        case ADDOP:     return "ADDOP";
        case MULOP:     return "MULOP";
        case POWER:     return "POWER";
        case 0:         return "EOF";
        default:        return "unknown token";        
    }
}
