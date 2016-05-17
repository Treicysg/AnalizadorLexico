all: ejecutableDenisse

ejecutableDenisse:
	flex preprocessor.l
	gcc -o preprocessor lex.yy.c -lfl
	flex scanner.l
	gcc -o scanner lex.yy.c -lfl
