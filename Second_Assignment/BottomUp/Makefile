objects = coursesexp.o lex.yy.o  

coursesexp.exe: $(objects)
	gcc -o coursesexp.exe $(objects)


lex.yy.o : lex.yy.c coursesexp.h
	gcc -c lex.yy.c

coursesexp.o : coursesexp.c coursesexp.h 
	gcc -c coursesexp.c
	
lex.yy.c : mylex.lex
	flex mylex.lex
	
clean :
	rm $(objects) coursesexp.exe *.yy.c
