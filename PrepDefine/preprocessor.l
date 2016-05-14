	/* ------------------------------------------------------------------------------------------------Definitions */

%{
	#include <stdio.h>
	#include <ctype.h>
	#include "global.h"
	int includeCounter = 0;
	int defineCounter = 0;
	char name[1024] = "";
	#define MAXIDLEN 33
	typedef char string[MAXIDLEN];
%}

number [0-9]
letter [a-zA-Z]
%%
  /* ------------------------------------------------------------------------------------------------ Rules */


#[ \t]*define {ECHO;defineCounter++;strcpy(name,yytext); return DEFINE;}
[ \t] {strcpy(name, yytext); return SPACE;}
[\n]	{strcpy(name,"");return NEWLINE;}
"if" {strcpy(name,yytext);    return CODIGO; }
"else" {strcpy(name,yytext);return CODIGO;  }
"while" {strcpy(name,yytext); return CODIGO;}
"for" {strcpy(name,yytext);  return CODIGO;}
{letter}({letter}|{number})* {strcpy(name,yytext); return CODIGO;}
#[ \t]*include[ \t"]+ {includeCounter++; return INCLUDE;}
{letter}({letter}|{number})*("."{letter}+)+ {strcpy(name,yytext);printf("%s\n",yytext);return FILENAME; }
"\"" {strcpy(name,yytext);return CODIGO;}
"\\n" {strcpy(name,yytext);  return CODIGO; }
"+" {strcpy(name,yytext);  return CODIGO; }
"-" {strcpy(name,yytext);     return CODIGO; }
"*" {strcpy(name,yytext);       return CODIGO;}
"(" {strcpy(name,yytext); return CODIGO;    }
")" {strcpy(name,yytext);    return CODIGO; }
"==" {strcpy(name,yytext); return CODIGO;   }
"=" {strcpy(name,yytext); return CODIGO;      }
"{" {strcpy(name,yytext);return CODIGO;     }
"}" {strcpy(name,yytext);return CODIGO;    }
";" {strcpy(name,yytext);  return CODIGO;}
"<=" {strcpy(name,yytext);  return CODIGO;   }
">=" {strcpy(name,yytext);  return CODIGO;   }
"<" {strcpy(name,yytext);  return CODIGO;    }
">" {strcpy(name,yytext);return CODIGO;     }
"," {strcpy(name,yytext);  return CODIGO;    }
"." {strcpy(name,yytext);    return CODIGO;  }
{number}({number})* {strcpy(name,yytext); return VALUE;}
. {strcpy(name,yytext);return CODIGO;}
<<EOF>> {  return EOF;}






%%
	/* --------------------------------------------------------------------------------------------------Code */
	void replace_define(FILE* fInput,char* nombre, char* valor){

		//FILE* replacedFile = tmpfile();
		FILE* replacedFile = fopen("eliminar.txt","w+");
		int ongoing_token;
		while((ongoing_token= yylex())!= EOF){
      printf("Rondaaa\n");
			if(ongoing_token == DEFINE){
				int n_tkn = yylex();
				while(n_tkn == SPACE || n_tkn==TAB){
					n_tkn = yylex();
				}
				if (strcmp(name,nombre)==0){
					printf("Define Repetidoooo llamado: %s. \n", nombre );
					exit(1);
				}else{
					fprintf(replacedFile,"#define ");
					fprintf(replacedFile,"%s",name);
				}
			}

		  else if (ongoing_token == SPACE){
				printf("Espacio");
				fprintf(replacedFile,"%s","  ");
			}
			else if(ongoing_token == VALUE){
				printf("VALUEE");
				fprintf(replacedFile,"%s",name);
			}
			else if(ongoing_token == FILENAME){
				printf("Filename");
				if (strcmp(name,nombre)==0){
					fprintf(replacedFile,"%s",valor);
				}else{
					fprintf(replacedFile,"%s",name);
      	}
			}
			else if(ongoing_token == CODIGO){
				printf("CODIGOOO");
				if (strcmp(name,nombre)==0){
					fprintf(replacedFile,"%s",valor);
				}else{
					fprintf(replacedFile,"%s",name);
      	}


			}else if (ongoing_token == NEWLINE){
				printf("nuevaLinea");
				fprintf(replacedFile,"%s","\n");
    	}else if (ongoing_token== TAB){
				printf("tab");
				fprintf(replacedFile,"%s","\t");
    	}


		}

}

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
		else if(current_token == DEFINE ){
			string cname;
			string value;
			current_token = yylex(); //espacio
			yylex(); //nombre
			strcpy(cname,name); //copia nombre
			current_token = yylex();// espacio
			current_token = yylex();// espera encontrar un valor
			if(current_token == VALUE || current_token == CODIGO){
				//printf("Lo que se espera que haya en el valor es: %s\n", name);
				strcpy(value,name);
			}

			//una vez encontrados,llamamos función que lo reemplaza
			replace_define(output,cname,value);

			printf("Nombre:%s\nValor:%s\n", cname,value);
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


main(int argc,char *argv){
	FILE *originalFile = fopen( "prueba.txt", "r" );
	FILE *output = fopen("outputFile.txt","w");

	//Creamos buffer para almacenar y recorrer el file original
	YY_BUFFER_STATE buffer = yy_create_buffer(originalFile,YY_BUF_SIZE);

	openFilePath(buffer, output);

}
