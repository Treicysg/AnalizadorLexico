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


#[ \t]*define {ECHO;defineCounter++; printf("Encontre un define \n");strcpy(name,yytext); return DEFINE;}
#[ \t]*include[ \t"]+ {includeCounter++; printf("Encontre un include \n"); }
[^ \t\n"]+   { strcpy(name,yytext);}
[\t] { return TAB;}
[a-zA-Z]([a-zA-Z]|[0-9])* {strcpy(name,yytext);}



%%
	/* --------------------------------------------------------------------------------------------------Code */
void copyIntoFile(FILE *file){
		char a;
		int c;
		FILE *output = fopen("outputFile.txt","w");
		if (file){
				while ((c = getc(file)) != EOF){
					putc(c, output);
				}
				fclose(file);
		}
		else{
			printf("Problem opening outputFile\n");
		}
	}

void openFilePath(){
	printf("Entre a la funcion que va a abrir el archivo %s\n", name);
	yylex();
	FILE* file = fopen(name, "r");
	if (file) {
			printf("leimos bien el file\n");
			copyIntoFile(file);

	}
	else{
		printf("Error al abrir el archivo %s\n", name);
	}
}

void processDefine(){
	char cname [1024];
	char value [1024];
	int current_token = yylex();
	if(current_token == DEFINE ){
		current_token = yylex();
		yylex();
		strcpy(cname,name);
		yylex();
		strcpy(value,name);
		printf("Nombre:%s\nValor:%s\n", cname,value);
	}

}

main(int argc,char *argv){
	yyin = fopen( "prueba.txt", "r" );
	//printf("Cantidad de includes: %d, Cantidad de defines: %d\n",includeCounter,defineCounter);
	//printf("El nombre del archivo: %s \n",name);
	openFilePath();
}
