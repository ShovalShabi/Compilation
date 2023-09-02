%code {

#include <stdio.h>
#include <string.h>

/* yylex () and yyerror() need to be declared here */
extern int yylex (void);
void yyerror (const char *s);

int numCourses = 0;
struct Course courses[2000] = {0};
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
  struct Course* myCourse;
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
    // Print the number of courses found
    printf("Number of total courses found: %d\n", numCourses);
};

course_list: course_list course;
course_list: %empty {};

course: NUM NAME CREDITS DEGREE SCHOOL elective {
    // Store the course information within the current struct the array
    $$->num = $1;
    strcpy($$->name, $2);
    $$->credits = $3;
    strcpy($$->degree, $4);
    strcpy($$->school, $5);
    if ($6) {
      $$->elective = 1;
    }
    courses[numCourses] = *$$; // Dereference the pointer and store it in the array
    numCourses++;

    // Optionally, you can print the course information here
    printf("Course: %s\n", $2);
    printf("Number: %d\n", $1);
    printf("Credits: %.2f\n", $3);
    printf("Degree: %s\n", $4);
    printf("School: %s\n", $5);
    printf("Is elective: %s\n", $6 ? "Yes" : "No");
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





