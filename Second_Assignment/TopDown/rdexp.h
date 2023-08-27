#ifndef EXPRESSION
#define EXPRESSION

// yylex returns 0 when EOF is encountered
enum token {
     LEFT_PAR = '(',
     RIGHT_PAR = ')',
     NUM = 300, 
     ADDOP,
     MULOP,
     POWER
};

char *token_name(enum token token);

enum op { PLUS, MINUS, MUL, DIV };

union _lexVal{
     int ival;
     enum op op;
};

extern union _lexVal lexicalValue;

void errorMsg(const char *s);

int power(int base, unsigned int exp);

#endif
