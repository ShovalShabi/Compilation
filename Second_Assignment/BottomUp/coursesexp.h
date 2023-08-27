#ifndef EXPRESSION
#define EXPRESSION

enum token {
     NUM = 300,
     NAME = 301,
     CREDITS = 302,
     DEGREE = 303,
     SCHOOL = 304,
     ELECTIVE = 305,
     COURSES = 306
};

char *token_name(enum token token);

union _lexVal{
     char lexeme[100];
     double credits;
};

extern union _lexVal yylval;

void errorMsg(const char *s);

#endif
