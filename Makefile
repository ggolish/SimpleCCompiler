phase4: phase4.lex.o phase4.tab.o stack.o
	gcc -o phase4 phase4.lex.o phase4.tab.o stack.o -lm

phase4.lex.o: phase4.lex.c phase4.tab.h 
	gcc -c phase4.lex.c

phase4.tab.o: phase4.tab.c stack.h
	gcc -c phase4.tab.c

phase4.tab.c phase4.tab.h: phase4.y stack.h
	bison -d phase4.y

phase4.lex.c: phase4.l phase4.tab.h 
	flex -o phase4.lex.c phase4.l

stack.o: stack.c stack.h
	gcc -c stack.c

phase3: phase3.lex.o phase3.tab.o
	gcc -o phase3 phase3.lex.o phase3.tab.o -lm

phase3.lex.o: phase3.lex.c phase3.tab.h
	gcc -c phase3.lex.c

phase3.tab.o: phase3.tab.c
	gcc -c phase3.tab.c

phase3.tab.c phase3.tab.h: phase3.y
	bison -d phase3.y

phase3.lex.c: phase3.l phase3.tab.h 
	flex -o phase3.lex.c phase3.l

phase2: phase2.lex.o phase2.tab.o
	gcc -o phase2 phase2.lex.o phase2.tab.o -lm

phase2.lex.o: phase2.lex.c phase2.tab.h
	gcc -c phase2.lex.c

phase2.tab.o: phase2.tab.c
	gcc -c phase2.tab.c

phase2.tab.c phase2.tab.h: phase2.y
	bison -d phase2.y

phase2.lex.c: phase2.l phase2.tab.h 
	flex -o phase2.lex.c phase2.l

phase1: phase1.lex.c
	gcc -o phase1 phase1.lex.c

phase1.lex.c: phase1.l
	flex -o phase1.lex.c phase1.l

clean:
	rm -f *.o *.lex.c *.tab.c *.tab.h phase[1234]
	
