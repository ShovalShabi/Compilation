objects = bisongen lex.yy.o
initiatedC = lex.yy.c grammar.tab.c
initiatedH = grammar.tab.h

bottomup.exe: $(objects)
	gcc $(initiatedC) -o coursesexp.exe

lex.yy.o : lex.yy.c
	gcc -c lex.yy.c
	
lex.yy.c : mylex.lex
	flex mylex.lex

bisongen:
	bison -d grammar.y
	
clean :
	rm $(objects) $(initiatedC) $(initiatedH)
