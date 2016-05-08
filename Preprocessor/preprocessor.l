	/* ------------------------------------------------------------------------------------------------Definitions */

%{
	#include <stdio.h>
	#include <ctype.h>
	#include "global.h"
	int includeCounter = 0;
	int defineCounter = 0;
	char name[1024] = "";
%}

%%
  /* ------------------------------------------------------------------------------------------------ Rules */


#[ \t]*define {ECHO;defineCounter++; printf("Encontre un define \n");}
#[ \t]*include[ \t]+ {includeCounter++; printf("Encontre un include \n"); }
[^ \t\n]+   { strcpy(name,yytext);}



%%
	/* --------------------------------------------------------------------------------------------------Code */

void openFilePath(){
	printf("Entre a la funcion que va a abrir el archivo %s\n", name);
	yylex();
	int c;
	FILE* file = fopen(name, "r");
	if (file) {
			printf("leimos bien el file\n");
	}
	else{
		printf("Error al abrir el archivo %s\n", name);
	}
}


main(int argc,char *argv){
	yyin = fopen( "prueba.txt", "r" );
	//printf("Cantidad de includes: %d, Cantidad de defines: %d\n",includeCounter,defineCounter);
	//printf("El nombre del archivo: %s \n",name);
	openFilePath();
}
