%code {

#include <stdio.h>
#include <string.h>

/* yylex () and yyerror() need to be declared here */
extern int yylex (void);
void yyerror (const char *s);

int numCourses = 0;
struct Course courses[2000] = {0};
double totalElectiveCred = 0;
int electiveCounter = 0;
int countAboveThreeCred = 0;

}


%code requires {
    struct Course {
    char name[100];
    int num;
    double credits;
    char degree[100];
    char school[100];
    int elective;
  };
}

/* note: no semicolon after the union */
%union {
  char lexeme[100];
  struct Course myCourse;
  double credits;
  int integer;
}

%token<lexeme> COURSES NAME DEGREE SCHOOL ELECTIVE
%token<credits> CREDITS
%token<integer> NUM

%type <myCourse> course_list course
%type <integer> elective;


%define parse.error verbose

%%

input: COURSES course_list {
    // Print the number of elective courses that found
    if (electiveCounter){
      printf("There are %d elecive courses\n", electiveCounter);
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
      printf("There are no elecive courses in this file!\n");


};

course_list: course_list course;
course_list: %empty {};

course: NUM NAME CREDITS DEGREE SCHOOL elective {
    // Store the course information within the current struct the array
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
    courses[numCourses] = $$; // Dereference the pointer and store it in the array
    numCourses++;
};

elective: ELECTIVE { $$ = 1; } | %empty { $$ = 0; };

%%


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
  
  yyparse ();
  
  fclose (yyin);
  return 0;
}

void yyerror (const char *s)
{
  extern int yylineno;
  fprintf (stderr, "line %d: %s\n", yylineno, s);
}





