#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "coursesexp.h"

#ifdef DEBUG
#define RETURN(f,v) { fprintf(stderr, "%s returned %d\n", f, v); return v;}
#else
#define RETURN(f,v) return v;
#endif    

extern enum token yylex (void);

// the recursive descent parser
int lookahead;
int numElective = 0;
int minThreeCredCnt = 0;
double electiveCred;

int currentCourse = 0;
char** coursesAndSchools =NULL;

void parse();
void input();
void course_list();
void course();

void match(int expectedToken){
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

void parse(){
    lookahead = yylex();
    input(); // input
    if (lookahead != 0) {  // 0 means EOF
        errorMsg("EOF expected");
        exit(1);
    }
}

void input() {
    if (lookahead == COURSES) {
        match(COURSES);
        course_list(); 
    }

    if (!numElective){
        printf("\n\nThere are no elective courses in this file!\n");
    }
    else{
        printf("\n\nThere are %d elective courses\n\n",numElective);

        printf("The total number of credits of the elective courses is %.2f\n\n",electiveCred);


        if (minThreeCredCnt){

            printf("The elective courses with 3 credits and more are:\n\n");

            printf("COURSE\t\tSCHOOL\n");

            printf("----------------------\n");

            for (int i = 0; i < minThreeCredCnt; i++){
                printf("%s\t%s\n",coursesAndSchools[i],coursesAndSchools[2*i + 1]);
            }

            for (int i = 0; i < minThreeCredCnt; i++){
                free(coursesAndSchools[i]);
            } 
            free(coursesAndSchools);
        }
        else{
            printf("There are no elective courses over 3 credits!\n");

        }
    }
}


void course_list(){ // a course_list is a sequence of factors seperated by white spaces

    if (lookahead == 0)
        return;    
    else 
        course();

    course_list();
}

void course() 
{
    char course[200];
    char school[200];
    int isElective = 0;
    double credits = 0;
    while(lookahead != 0) {
        switch (lookahead) {
            case NUM:
                match(NUM); 
                break;

            case NAME:
                strcpy(course,yylval.lexeme);
                match(NAME); 
                break; 

            case CREDITS:
  
                credits = yylval.credits; 
                match(CREDITS); 
                break;

            case DEGREE:
                match(DEGREE); 
                break;

            case SCHOOL:
                strcpy(school,yylval.lexeme);
                match(SCHOOL);
                break;

            case ELECTIVE:
                match(ELECTIVE);
                numElective ++;
                electiveCred += credits;

                if (credits >= 3){
                    minThreeCredCnt++;

                    coursesAndSchools = (char**) realloc(coursesAndSchools, (currentCourse + 2) * sizeof(char*));

                    if (!coursesAndSchools)
                    {
                        printf("error: cannot allocate memory");
                        exit(1);    
                    }

                    coursesAndSchools[currentCourse] = strdup(course);
                    coursesAndSchools[currentCourse + 1] = strdup(school);
                    currentCourse +=2;
                }
                break;

            default:
                char e[100];
                sprintf(e,"error: expected number or left parenthesis, found token %s", token_name(lookahead));
                exit(1);              
                break;
        }
    } 
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

