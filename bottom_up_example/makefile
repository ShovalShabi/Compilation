CC = gcc

#first target is the default target
exp: lex.yy.o exp.tab.o
	$(CC) lex.yy.o exp.tab.o -o exp
	
exp.tab.c exp.tab.h: exp.y
	bison -d exp.y
	
lex.yy.c: exp.lex
	flex exp.lex

lex.yy.o: lex.yy.c exp.tab.h
	$(CC) -c lex.yy.c
	
exp.tab.o: exp.tab.c exp.tab.h
#	$(CC) -c exp.tab.c

# clean is a 'phony target'  (not a file)	
clean:
	rm -f exp exp.tab.o lex.yy.o exp.tab.c exp.tab.h lex.yy.c
	
	
	