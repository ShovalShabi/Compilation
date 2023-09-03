%code {

#include <stdio.h>
#include <string.h>

/* Declarations for external functions yylex () and yyerror() */
extern int yylex (void);
void yyerror (const char *s);

// Variables to keep track of course data
int numCourses = 0;
struct Course courses[2000] = {0};
double totalElectiveCred = 0;
int electiveCounter = 0;
int countAboveThreeCred = 0;
}


%code requires {
    // Definition of the Course structure
    struct Course {
    char name[100];
    int num;
    double credits;
    char degree[100];
    char school[100];
    int elective;
  };
}

/* Union to handle different token types */
%union {
  char lexeme[100];
  struct Course myCourse;  // Course information
  double credits;         // Credits value
  int integer;            // Integer value
}

// Token definitions with associated types
%token<lexeme> COURSES NAME DEGREE SCHOOL ELECTIVE
%token<credits> CREDITS
%token<integer> NUM

// Declaration of types for non-terminals
%type <myCourse> course_list course
%type <integer> elective;

%define parse.error verbose

%%

// Start rule for the parser
input: COURSES course_list {
    // Print the number of elective courses found
    if (electiveCounter){
      printf("There are %d elective courses\n", electiveCounter);
      printf("\nThe total number of credits of the elective courses is %.2f\n", totalElectiveCred);
      if(countAboveThreeCred){
        printf("\nThe elective courses with 3 credits or more are:\n");
        printf("\nCOURSE\t\tSCHOOL\n");
        printf("----------------------\n");
        for(int i=0; i<numCourses; i++){
          if(courses[i].elective && courses[i].credits >= 3)
            printf("%s\t%s\n",courses[i].name,courses[i].school);
        }
      }
      else
        printf("There are no elective courses over 3 credits!\n");
      
    }
    else
      printf("There are no elective courses in this file!\n");
};

// Rule to handle lists of courses
course_list: course_list course;
course_list: %empty {};

// Rule to handle individual courses
course: NUM NAME CREDITS DEGREE SCHOOL elective {
    $$.num = $1;
    strcpy($$.name, $2);
    $$.credits = $3;
    strcpy($$.degree, $4);
    strcpy($$.school, $5);
    if ($6) {
      $$.elective = 1;
      totalElectiveCred += $$.credits;
      if ($$.credits >= 3)
        countAboveThreeCred++;
      electiveCounter++;
    }
    courses[numCourses] = $$; // Store the course in the array
    numCourses++;
};

// Rule to handle the ELECTIVE token
elective: ELECTIVE { $$ = 1; } | %empty { $$ = 0; };

%%

// Main function to start the parser
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
  
  yyparse ();  // Start the parsing process
  
  fclose (yyin);
  return 0;
}

// Error handling function
void yyerror (const char *s)
{
  extern int yylineno;
  fprintf (stderr, "line %d: %s\n", yylineno, s);
}

