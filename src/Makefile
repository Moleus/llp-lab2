all: build

run:
	./main

build:
	yacc --debug -d -Wall parser.y
	flex lexer.l
	gcc main.c types.c lex.yy.c y.tab.c -o main

clean:
	rm -f lex.yy.c main parser.tab.c parser.tab.h y.tab.c y.tab.h

.PHONY:	clean