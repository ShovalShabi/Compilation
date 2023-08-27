%code requires {
   struct mydate { int day, month, year; }
}

%union {
   int ival;
   struct date d;
} 

%token <ival> NUM

%nterm <d> date

%%

line:  date { printf("day=%d, month=%d, year=%d\n",
                $1.day, $1.month, $1.year); }


   /* 30/11/2001 */
date:  NUM '/' NUM '/' NUM
   {  $$.day = $1; 
      $$.month = $3;
	  $$.year = $5; }


