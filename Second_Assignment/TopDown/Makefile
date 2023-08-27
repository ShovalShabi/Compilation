objects = rdexp.o lex.yy.o  

rdexp.exe: $(objects)
	gcc -o rdexp.exe $(objects)


lex.yy.o : lex.yy.c rdexp.h
	gcc -c lex.yy.c

rdexp.o : rdexp.c rdexp.h 
	gcc -c rdexp.c
	
lex.yy.c : rdexp.lex
	flex rdexp.lex
	
clean :
	rm $(objects) rdexp.exe
