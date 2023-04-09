useless:
	bison -d -v -r all parser.y
	flex justLexer.l
	gcc -o mycomp lex.yy.c parser.tab.c cgen.c -lfl
	./mycomp < ./lexer_test/useless.th > ./lexer_test/useless.c
	gcc ./lexer_test/useless.c -o main.out

prime:
	bison -d -v -r all myparser.y
	flex mylexer.l
	gcc -o mycomp lex.yy.c myparser.tab.c cgen.c -lfl
	./mycomp < prime.tc > prime.c
	gcc prime.c -o main.out
	./main.out

mypropg: 
	bison -d -v -r all myparser.y
	flex mylexer.l
	gcc -o mycomp lex.yy.c myparser.tab.c cgen.c -lfl
	./mycomp < myprog.tc > myprog.c
	gcc myprog.c -o main.out
	./main.out
