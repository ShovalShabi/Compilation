/* 
    This is an example of a recursive descent parser that handles arithmetic expressions.
    
    This program reads an expression from the input and writes the value
    of the expression to the standard output.
          
    example input:  3 + 4 * 5 ^ 2    (^ is exponentiation operator)

  To prepare the program, issue the following commands from
  The command line:
  
  flex rdexp.lex    (This will generate a file called lex.yy.c)
    
  compile the program using a C compiler
  for example: 
       gcc lex.yy.c rdexp.c -o rdexp.exe
       
  (note that file rdexp.h is part of the program (it's included in
     other files)
       
  The input file for the program should be supplied as a command line argument
  for example:
      rdexp.exe  rdexp.txt
      
      
  Here is a grammar describing the input
  (tokens are written using uppercase letters or as letters surrounded by quote marks):
  
    expression -> expression ADDOP term | term 
    term -> term MULOP factor | factor
    factor -> p POWER factor | p
    p -> '(' exp ')' | NUM
    
    The POWER operater is right associative. The other operators are left associative.
    
    
    Note that this grammar is not LL(1) because of the left recursion
    in the productions for expression and term. It is not hard to find an equivalent LL(1) grammar
    but this was not necessary. See the functions exp() and term().

*/
#include <stdio.h>
#include <stdlib.h>  /* for exit() */
#include "rdexp.h"

#ifdef DEBUG
#define RETURN(f,v) { fprintf(stderr, "%s returned %d\n", f, v); return v;}
#else
#define RETURN(f,v) return v;
#endif    

extern enum token yylex (void);

// the recursive descent parser
int lookahead;

void parse();
int expression();
int term();
int factor();
int p();

void match(int expectedToken)
{
#ifdef DEBUG
    fprintf(stderr, "calling match %d (token %s)\n", expectedToken, token_name(expectedToken));
#endif
    if (lookahead == expectedToken)
        lookahead = yylex();
    else {
        char e[100]; 
        sprintf(e, "error: expected token %s, found token %s", 
                token_name(expectedToken), token_name(lookahead));
        errorMsg(e);
        exit(1);
    }
}

void parse()
{
    lookahead = yylex();
    int value = expression();
    if (lookahead != 0) {  // 0 means EOF
        errorMsg("EOF expected");
        exit(1);
    }
    printf("value is %d\n", value);
}

int expression() // an expression is a sequence of terms seperated by ADDOPs
{
    int value = term();
    while (lookahead == ADDOP) {
        enum op op = lexicalValue.op;
        match(ADDOP);
        int v = term();
        value = (op == PLUS)? value + v : value - v;        
    }
    RETURN("expression", value);
        
}

int term() // a term is a sequence of factors seperated by MULOPs
{
    int value = factor();
    while (lookahead == MULOP) {
        enum op op = lexicalValue.op;
        match(MULOP);
        int v = factor();
        value = (op == MUL)? value * v : value / v;        
    }
    RETURN("term", value);
}

int factor() /* note that POWER is right associative */
{
    int base = p();
    if (lookahead == POWER) {
        match(POWER);
        int exponent = factor();
        RETURN("factor", power(base, exponent));
    }
    RETURN("factor", base);
}

int p() 
{
    int value;
    switch (lookahead) {
        case '(':  match('('); 
                   value = expression();
                   match(')');
                   break;
        case NUM:  value = lexicalValue.ival; match(NUM); break;
        
        default:   { char e[100]; 
                     sprintf(e, "error: expected number or left parenthesis, found token %s", 
                           token_name(lookahead));
                     errorMsg(e);
                     exit(1);
                   }
    }
    RETURN("p", value);    
}

int
main (int argc, char **argv)
{
    extern FILE *yyin;
    if (argc != 2) {
       fprintf (stderr, "Usage: %s <input-file-name>\n", argv[0]);
	   return 1;
    }
    yyin = fopen (argv [1], "r");
    if (yyin == NULL) {
       fprintf (stderr, "failed to open %s\n", argv[1]);
	   return 2;
    }
  
    parse();
  
    fclose (yyin);
    return 0;
}

void errorMsg(const char *s)
{
  extern int yylineno;
  fprintf (stderr, "line %d: %s\n", yylineno, s);
}

int power(int base, unsigned int exp) {
    int i, result = 1;
    for (i = 0; i < exp; i++)
        result *= base;
    return result;
}





