	/* ------------------------------------------------------------------------------------------------Definitions */

%{
	#include <stdio.h>
	#include <ctype.h>
	#include "global.h"
	int includeCounter = 0;
	int defineCounter = 0;
	char name[1024] = "";
	int current_token;
	char included_Files[50][512];
	int includedFiles_count = 0;
%}

number [0-9]
letter [a-zA-Z]
%%
  /* ------------------------------------------------------------------------------------------------ Rules */


#[ \t]*define {defineCounter++;strcpy(name,yytext); return DEFINE;}
[ \t] {strcpy(name, yytext); return SPACE;}
[\n]	{strcpy(name,"");return NEWLINE;}
"\"" {strcpy(name,yytext);return QUOTES;}
"<"{letter}({letter}|{number})*("."{letter}+)+">" {strcpy(name, yytext); return LIBRARY;}
{letter}({letter}|{number})* {strcpy(name,yytext); return CODIGO;}
#[ \t]*include[ \t]+ {strcpy(name,yytext);includeCounter++; return INCLUDE;}
{letter}({letter}|{number})*("."{letter}+)+ {strcpy(name,yytext);return FILENAME; }
<<EOF>> {strcpy(name,"EOF"); return EOF;}
. {strcpy(name,yytext);return CODIGO;}






%%
	/* --------------------------------------------------------------------------------------------------Code */

void openFilePath(YY_BUFFER_STATE buffer,FILE *output){
	yy_switch_to_buffer (buffer); // Nos pasamos al buffer principal.
	printf("Llevamos %d files incluidos\n", includedFiles_count);

	while((current_token= yylex())!= EOF){
		// Mientras haya algo que leer...
		if(current_token == INCLUDE){
				current_token = yylex(); // verifica que el file path empiece con comillas
				if(current_token == QUOTES){
					printf("Encontramos las comillas principales\n");
					current_token = yylex(); //obtenemos el nombre del archivo
					if (current_token == FILENAME){
						FILE* file = fopen(name, "r");
						if (file) {
								if (isIncluded(name)){
									printf("Error, ya se ha incluido el file %s\n",name);
									exit(0);
								}
								add_includedFile(name);
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
				else if(current_token == LIBRARY){
					// Copia datos
					fprintf(output,"#include %s", name);
				}
				else{
					printf("File path no valido. faltan comillas iniciales \n");
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

void check_all_tokens(YY_BUFFER_STATE buffer){
	yy_switch_to_buffer (buffer); // Nos pasamos al buffer principal.

	while((current_token= yylex())!= EOF){
		if(current_token == INCLUDE){
			printf("INCLUDE = %s\n", name);
		}
		else if(current_token == DEFINE){
			printf("DEFINE = %s\n", name);
		}
		else if(current_token == SPACE){
			printf("SPACE = %s\n", name);
		}
		else if(current_token == NEWLINE){
			printf("NEWLINE = %s\n", name);
		}
		else if(current_token == QUOTES){
			printf("QUOTES = %s\n", name);
		}
		else if(current_token == CODIGO){
			printf("CODIGO = %s\n", name);
		}
		else if(current_token == INCLUDE){
			printf("INCLUDE = %s\n", name);
		}
		else if(current_token == FILENAME){
			printf("FILENAME = %s\n", name);
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

void clear_includedFilesList(){
	int i;
  for(i = 0;i < 50;i++){
    strcpy(included_Files[i],"NULL");
  }
}

void add_includedFile(char* filename){
	if(includedFiles_count == 50){
		printf("Ya no se pueden incluir mas files\n");
		exit(0);
	}
	strcpy(included_Files[includedFiles_count],filename);
	includedFiles_count ++;

}

bool isIncluded(char* filename){
	int i = 0;
	bool isIncluded = false;
	while(i<50){
		if(strcmp(filename,included_Files[i])==0){
			isIncluded = true;
		}
		i++;
	}
	return isIncluded;
}

void preprocess_file(FILE *originalFile, char* filename){
	if(originalFile){
		add_includedFile(filename);
		YY_BUFFER_STATE buffer = yy_create_buffer(originalFile,YY_BUF_SIZE); //Creamos buffer para almacenar y recorrer el file original
	  FILE *output = fopen("outputFile.txt","w");
	 	openFilePath(buffer, output);
	 	//processDefine();
	 	//check_all_tokens(buffer);
		fclose(originalFile);
	}
	else{
		printf("Error al abrir el archivo especificado. Intentelo nuevamente.");
		exit(0);
	}
}

main(int argc,char *argv){
	char filename [100]="";
	printf( "Ingrese el archivo: ");
	scanf("%s",filename);
	FILE *originalFile = fopen( filename, "r" );
	preprocess_file(originalFile, filename);
}
