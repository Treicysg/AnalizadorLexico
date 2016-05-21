	/* ------------------------------------------------------------------------------------------------Definitions */

%{
	#include <stdio.h>
	#include <ctype.h>
	#include "global.h"
	int includeCounter = 0;
	int defineCounter = 0;
	char name[1024] = "";
%}

number [0-9]
letter [a-zA-Z]
%%
  /* ------------------------------------------------------------------------------------------------ Rules */


#[ \t]*define {ECHO;defineCounter++;strcpy(name,yytext); return DEFINE;}
[ \t] {strcpy(name, yytext); return SPACE;}
[\n]	{strcpy(name,"");return NEWLINE;}
{letter}({letter}|{number})* {strcpy(name,yytext); return CODIGO;}
#[ \t]*include[ \t"]+ {includeCounter++; return INCLUDE;}
{letter}({letter}|{number})*("."{letter}+)+ {strcpy(name,yytext);printf("%s\n",yytext);return FILENAME; }
<<EOF>> {  return EOF;}
. {strcpy(name,yytext);return CODIGO;}






%%
	/* --------------------------------------------------------------------------------------------------Code */

void openFilePath(YY_BUFFER_STATE buffer,FILE *output){
	int current_token;
	yy_switch_to_buffer (buffer); // Nos pasamos al buffer principal.

	while((current_token= yylex())!= EOF){
		// Mientras haya algo que leer...

		if(current_token == INCLUDE){
			current_token = yylex(); // obtiene archivo

			if (current_token == FILENAME){
				FILE* file = fopen(name, "r");
				if (file) {
						printf("leimos bien el file\n");
						readIncludeFile(file, output);
				}
				else{
					printf("Error al abrir el archivo %s\n", name);
					exit(0);
				}
			}
			else{
				printf("Error. '%s' no es un file path valido.\n", name);
				exit(0);
			}
		}

		//Copiara en el output file los datos de los archivos incluidos
		else if(current_token == CODIGO){
			// Copia datos
			fprintf(output,"%s", name);
		}
		else if(current_token == SPACE){
			// Copia espacios
			fprintf(output,"%s", name);
		}
		else if(current_token == NEWLINE){
			// Copia cambios de linea
			fprintf(output,"%s", "\n");
		}
	}

}

void readIncludeFile(FILE *file, FILE *output){
		char a;
		int c;
		if (file){
			if(output){
				YY_BUFFER_STATE bufferInclude = yy_create_buffer(file,YY_BUF_SIZE);
				if(bufferInclude){
					printf("Si hay un buffer INclude");
					yypush_buffer_state(YY_CURRENT_BUFFER);
					openFilePath(bufferInclude,output);
					yypop_buffer_state ();
					yylex();
				}
				else{
					printf("Error con el nuevo buffer Include");
				}
			}
			else{
				printf("Problem with output file");
			}
		}
		else{
			printf("Problem with incluyeme file\n");
		}
	}

void processDefine(){
	char cname [1024];
	char value [1024];
	int current_token = yylex();
	if(current_token == DEFINE ){
		current_token = yylex(); //espacio
		yylex(); //nombre
		strcpy(cname,name);
		yylex();// espacio
		yylex();
		strcpy(value,name);
		printf("Nombre:%s\nValor:%s\n", cname,value);
	}

}

main(int argc,char *argv){
	FILE *originalFile = fopen( "prueba.txt", "r" );
	FILE *output = fopen("outputFile.txt","w");

	//Creamos buffer para almacenar y recorrer el file original
	YY_BUFFER_STATE buffer = yy_create_buffer(originalFile,YY_BUF_SIZE);

	openFilePath(buffer, output);
	//processDefine();
}
