%code {

/* 
This  program reads a list  of songs  from its input.
It prints the length (in minutes and seconds) of the shortest song
   that satisfies the following conditions:
     (1)  Its length is at least 4:02  (4 minutes and 2 seconds)
     (2)  The artist is known by one name only (for example
          Madonna  but not Joe Cocker)
          
For an example of an input, see file madonna.txt 

To prepare the program, issue the following commands from
  The command line:
  
  flex madonna.lex    (This will generate a file called lex.yy.c)
  bison -d madonna.y  (This will generate files madonna.tab.c & madonna.tab.h)
  
  compile  the files  that flex and bison generated with a C compiler
  for example: 
       gcc lex.yy.c madonna.tab.c -o madonna.exe
       
  The input file for the program should be supplied as a command line argument
  for example:
      madonna.exe  madonna.txt

*/
#include <stdio.h>

  /* yylex () and yyerror() need to be declared here */
extern int yylex (void);
void yyerror (const char *s);

struct time
min_time (struct time t1, struct time t2);
}

%code requires {
    struct time {
         int minutes;  /* -1  means irrelevant */ 
         int seconds; 
    };
}

/* note: no semicolon after the union */
%union {
   int number_of_names;
   struct time _time;
}

%token PLAYLIST SEQ_NUM SONG ARTIST LENGTH SONG_NAME 
%token NAME
%token <_time> SONG_LENGTH 

%type <_time> songlist song
%type <number_of_names> artist_name

%error-verbose

%%

start: PLAYLIST songlist 
       { if ($2.minutes == -1) 
             printf ("no relevant song\n");
         else
             printf ("time for shortest relevant song: %d:%.2d\n",
                            $2.minutes, $2.seconds);
       };
       
songlist: /* empty */   { $$.minutes = -1;
                          $$.seconds = -1;
                        };
                        
songlist: songlist song { $$ = min_time($1, $2); };

song: SEQ_NUM  SONG SONG_NAME  ARTIST artist_name LENGTH SONG_LENGTH
       {  if ($5 == 1 && ($7.minutes > 4 || $7.minutes == 4 &&
                                            $7.seconds >= 2))
              $$ = $7;
          else {
              $$.minutes = -1;
              $$.seconds = -1;
          }
       };

artist_name: NAME { $$ = 1; }
           | NAME NAME { $$ = 2; }
           ;           

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
  extern int line;
  fprintf (stderr, "line %d: %s\n", line, s);
}

struct time
min_time (struct time t1, struct time t2)
{
     if (t1.minutes == -1)
         return t2;
     else if (t2.minutes == -1)
         return t1;
         
     if (t1.minutes < t2.minutes || (t1.minutes == t2.minutes &&
                                     t1.seconds < t2.seconds))
          return t1;
     return t2;
}
