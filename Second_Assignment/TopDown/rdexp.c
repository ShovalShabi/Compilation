/* 
    This is an example of a recursive descent parser that handles arithmetic inputs.
    
    This program reads an input from the input and writes the value
    of the input to the standard output.
          
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
  
    input -> input ADDOP course_list | course_list 
    course_list -> course_list MULOP factor | factor
    factor -> p POWER factor | p
    p -> '(' exp ')' | NUM
    
    The POWER operater is right associative. The other operators are left associative.
    
    
    Note that this grammar is not LL(1) because of the left recursion
    in the productions for input and course_list. It is not hard to find an equivalent LL(1) grammar
    but this was not necessary. See the functions exp() and course_list().

*/
#include <stdio.h>
#include <stdlib.h> 
#include "rdexp.h"

#ifdef DEBUG
#define RETURN(f,v) { fprintf(stderr, "%s returned %d\n", f, v); return v;}
#else
#define RETURN(f,v) return v;
#endif    

extern enum token yylex (void);

// the recursive descent parser
int lookahead;
int num_elective_courses;
double total_credits;
int atleast_3_credits;

void parse();
int input();
int course_list();
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
    input(); // input
    if (lookahead != 0) {  // 0 means EOF
        errorMsg("EOF expected");
        exit(1);
    }
}

// input: COURSES course_list;
int input() 
{
    char* value;
    if (lookahead == COURSES) {
        value = course_list();
    }
    printf("There are %d elective courses\n", value);
    RETURN("input", value);
        
}

int course_list() // a course_list is a sequence of factors seperated by MULOPs
{ 
   while(lookahead != 0) {
              
   } 
}

int course() 
{
    int value;
    double credits;

    switch (lookahead) {
        case NUM: 
            match(NUM); 
            break;
        case NAME: 
            match(NAME); 
            break; 
        case CREDITS:  
            credits = lexicalValue.credits; 
            match(CREDITS); 
            break;
        case DEGREE:  
            value = lexicalValue.lexeme; 
            match(DEGREE); 
            break;
        case ELECTIVE:
            total_credits += credits;
            if (credits > 3.0) atleast_3_credits++;
        default:   
            break;
    }
    return value;  
}

int elective() // an input is a sequence of course_lists seperated by ADDOPs
{
    if(match(ELECTIVE)) {
        return 1;
    }
    return 0;       
}

int main (int argc, char **argv)
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






