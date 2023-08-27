%code {
#include <stdio.h>

  /* yylex () and yyerror() need to be declared here */
extern int yylex (void);
void yyerror (const char *s);
}

%code requires {
    enum operator {PLUS, MINUS, MUL, DIV };
}

/* note: no semicolon after the union */
/* this will be the type of all semantic values. 
   yylval will have this type 
*/
%union {
   int ival;
   enum operator op;
}

%token <ival> NUM
%token <op> ADDOP MULOP

%token '(' /* character literal */

%nterm <ival> expression term factor 

/* %type <ival> expression */
 
%error-verbose

%%
line: expression { printf ("value is %d\n", $1); } ;
                          
expression : expression ADDOP term    
                  { if ($2 == PLUS)
                       $$ = $1 + $3;
                    else 
                       $$ = $1 - $3;
                  }
                  
           | term  { $$ = $1; }
           ;
term       : term MULOP factor
                  { if ($2 == MUL)
                       $$ = $1 * $3;
                    else 
                       $$ = $1 / $3;
                  }
  
           | factor { $$ = $1; }
           ;
factor     : '(' expression ')' { $$ = $2; }
           |  NUM               { $$ = $1; }
	       ;
		   
%%
int main (int argc, char **argv)
{
  extern FILE *yyin; /* defined by flex */
  if (argc != 2) {
     fprintf (stderr, "Usage: %s <input-file-name>\n", argv[0]);
	 return 1;
  }
  yyin = fopen (argv [1], "r");
  if (yyin == NULL) {
       fprintf (stderr, "failed to open %s\n", argv[1]);
	   return 2;
  }
#if 0

#ifdef YYDEBUG
   yydebug = 1;
#endif
#endif
  yyparse ();
  
  fclose (yyin);
  return 0;
}

/* called by yyparse() whenever a syntax error is detected */
void yyerror (const char *s)
{
  extern int yylineno; // defined by flex
  
  fprintf (stderr, "hello world. line %d:%s\n", yylineno,s);
}





