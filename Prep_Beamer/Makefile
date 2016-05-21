all: ejecutableDenisse

ejecutableDenisse:

	flex --prefix=pprc pprc_preprocessor.l
	flex scanner.l
	gcc -g -o Main Main.c prep_preprocessor.c prep_scanner.c  -lfl
