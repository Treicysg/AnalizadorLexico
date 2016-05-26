	/* ------------------------------------------------------------------------------------------------Definitions */
%option yylineno
%option header-file = "prep_preprocessor.h"
%option outfile = "prep_preprocessor.c"
%option noyywrap
%{
	#include <stdio.h>
	#include <ctype.h>
	#include "global.h"
	int includeCounter = 0;
	int defineCounter = 0;
	char _name[1024] = "";
	int current_token;
	char included_Files[50][512];
	int includedFiles_count = 0;
	#define MAXIDLEN 33
 typedef char string[MAXIDLEN];
%}

number [0-9]
letter [a-zA-Z]
string 		\"(\\.|[^"])*\"
%%
  /* ------------------------------------------------------------------------------------------------ Rules */


#[ \t]*define[ \t]+ {defineCounter++;strcpy(_name,yytext); return DEFINE;}
{number}({number})* {strcpy(_name,yytext); return VALUE;}
[ \t] {strcpy(_name, yytext); return SPACE;}
[\n]	{strcpy(_name,yytext);return NEWLINE;}
"\"" {strcpy(_name,yytext);return QUOTES;}
"<"{letter}({letter}|{number})*("."{letter}+)+">" {strcpy(_name, yytext); return LIBRARY;}
{letter}({letter}|{number})* {strcpy(_name,yytext); return CODIGO;}
#[ \t]*include[ \t]+ {strcpy(_name,yytext);includeCounter++; return INCLUDE;}
[_]*{letter}({letter}|{number}|[_]*)*("."{letter}+)+ {strcpy(_name,yytext);return FILENAME; }
"%s" {strcpy(_name,yytext);return PRINTSTRING;}
<<EOF>> {strcpy(_name,"EOF"); return EOF;}
. {strcpy(_name,yytext);return CODIGO;}






%%
	/* --------------------------------------------------------------------------------------------------Code */

	YY_BUFFER_STATE replace_define(char* nombre, char* valor){
		FILE* processed_File = fopen("fileDefine.txt","w+");
	  int ongoing_token;
	  while((ongoing_token= yylex())!= EOF){
	   if(ongoing_token == DEFINE){
			 ongoing_token = yylex(); //Obtenemos el nombre de la variable
	    if (strcmp(_name,nombre)==0){
	     printf("Define Repetidoooo llamado: %s. \n", nombre );
	     //exit(1);
	    }else{
	     fprintf(processed_File,"#define ");
	     fprintf(processed_File,"%s",_name);
	    }
	   }
		 else if (ongoing_token == SPACE){
	    //printf("Espacio");
	    fprintf(processed_File,"%s",_name);
	   }
	   else if(ongoing_token == VALUE){
	    //printf("VALUEE");
	    fprintf(processed_File,"%s",_name);
	   }
	   else if(ongoing_token == FILENAME){
	    //printf("FILENAME");
	    if (strcmp(_name,nombre)==0){
	     fprintf(processed_File,"%s",valor);
	    }else{
	     fprintf(processed_File,"%s",_name);
	       }
	   }
	   else if(ongoing_token == CODIGO){
	    //printf("CODIGOOO");
	    if (strcmp(_name,nombre)==0){
	     fprintf(processed_File,"%s",valor);
	    }else{
	     fprintf(processed_File,"%s",_name);
	       }

	   }else if (ongoing_token == NEWLINE){
	    //printf("nuevaLinea");
	    fprintf(processed_File,"%s","\n");
	   }
		 else if (ongoing_token== TAB){
	    //printf("tab");
	    fprintf(processed_File,"%s","\t");
	    }

	  }
		fseek(processed_File,0,SEEK_SET);
    YY_BUFFER_STATE bufferDefine = yy_create_buffer(processed_File,YY_BUF_SIZE);
		return bufferDefine;
	}

	void processDefine(YY_BUFFER_STATE bufferFinal,FILE* processed_File){
		yy_switch_to_buffer (bufferFinal); // Nos pasamos al buffer principal.

		while((current_token= yylex())!= EOF){
			// Mientras haya algo que leer...
			if(current_token == DEFINE){
				printf("Estoy procesando el define\n");
			   string c_name;
			   string value;
			   yylex(); //nombre
			   strcpy(c_name,_name); //copia nombre
			   current_token = yylex();// espacio
			   current_token = yylex();// espera encontrar un valor
			   if(current_token == VALUE || current_token == CODIGO){
			    //printf("Lo que se espera que haya en el valor es: %s\n", _name);
			    strcpy(value,_name);
			   }
				 //printf("Current Token %s\n", _name);
			   //una vez encontrados,llamamos función que lo reemplaza
				 //printf("Se reemplaza -> Nombre:%s\nValor:%s\n", c_name,value);
				 yylex();
			   YY_BUFFER_STATE bufferDef = replace_define(c_name,value);
				 yy_switch_to_buffer (bufferDef);
				 //check_all_tokens(bufferDef);
			}
			//Copiara en el output file los datos de los archivos incluidos
			else if(current_token == CODIGO){
				// Copia datos
				fprintf(processed_File,"%s", _name);
			}
			else if(current_token == SPACE){
				// Copia espacios
				fprintf(processed_File,"%s", _name);
			}
			else if(current_token == NEWLINE){
				// Copia cambios de linea
				fprintf(processed_File,"%s", "\n");
			}
			else if(current_token == FILENAME){
				// Copia cambios de linea
				fprintf(processed_File,"%s", "\n");
			}
			else if(current_token == VALUE){
				// Copia cambios de linea
				fprintf(processed_File,"%s", _name);
			}
		}
	}


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
						FILE* file = fopen(_name, "r");
						if (file) {
								if (isIncluded(_name)){
									printf("Error, ya se ha incluido el file %s\n",_name);
									exit(0);
								}
								add_includedFile(_name);
								readIncludeFile(file, output);
						}
						else{
							printf("Error al abrir el archivo %s\n", _name);
							exit(0);
						}
					}
					else{
						printf("Error. '%s' no es un file path valido.\n", _name);
						exit(0);
					}
				}
				else if(current_token == LIBRARY){
					// Copia datos
					fprintf(output,"#include %s", _name);
				}
				else if(current_token == PRINTSTRING){
					fprintf(output,"#include %s", _name);
				}
				else{
					printf(" File path no valido. faltan comillas iniciales %s \n", yytext);
					exit(0);
				}
		}

		//Copiara en el output file los datos de los archivos incluidos
		else if(current_token == CODIGO){
			// Copia datos
			fprintf(output,"%s", _name);
		}
		else if(current_token == SPACE){
			// Copia espacios
			fprintf(output,"%s", _name);
		}
		else if(current_token == NEWLINE){
			// Copia cambios de linea
			fprintf(output,"%s", "\n");
		}
		else if(current_token == DEFINE){
			// Copia cambios de linea
			fprintf(output,"%s", _name);
		}
		else if(current_token == VALUE){
			// Copia cambios de linea
			fprintf(output,"%s",_name);
		}
		else if(current_token == QUOTES){
			// Copia cambios de linea
			fprintf(output,"%s",_name);
		}
		else if(current_token == LIBRARY){
			// Copia cambios de linea
			fprintf(output,"%s", _name);
		}
	}
}

void clear_token_buffer(){
	memset(token_type, 0, 105);
	memset(token_quantity, 0, 105);
}


void check_all_tokens(YY_BUFFER_STATE buffer){
	yy_switch_to_buffer (buffer); // Nos pasamos al buffer principal.

	while((current_token= yylex())!= EOF){
		if(current_token == INCLUDE){
			printf("INCLUDE = %s\n", _name);
		}
		else if(current_token == DEFINE){
			printf("DEFINE = %s\n", _name);
		}
		else if(current_token == SPACE){
			printf("SPACE = %s\n", _name);
		}
		else if(current_token == NEWLINE){
			printf("NEWLINE = %s\n", _name);
		}
		else if(current_token == QUOTES){
			printf("QUOTES = %s\n", _name);
		}
		else if(current_token == CODIGO){
			printf("CODIGO = %s\n", _name);
		}
		else if(current_token == INCLUDE){
			printf("INCLUDE = %s\n", _name);
		}
		else if(current_token == FILENAME){
			printf("FILENAME = %s\n", _name);
		}
		else if(current_token == VALUE){
			printf("VALUE = %s\n", _name);
		}
		else if(current_token == LIBRARY){
			printf("LIBRARY = %s\n", _name);
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
		fclose(output);
		fclose(originalFile);

		FILE *final_input = fopen("outputFile.txt","r");
		if(final_input){
			YY_BUFFER_STATE bufferFinal = yy_create_buffer(final_input,YY_BUF_SIZE); //Creamos buffer para almacenar y recorrer el file con todos los includes
			FILE *processed_File = fopen("processedFile.txt","w");
			processDefine(bufferFinal,processed_File);
			//check_all_tokens(bufferFinal);
			fclose(processed_File);
		}
	}
	else{
		printf("Error al abrir el archivo especificado. Intentelo nuevamente.");
		exit(0);
	}
}

void readFile(){
	char filename [100]="";
	printf( "Ingrese el archivo: ");
	scanf("%s",filename);
	FILE *originalFile = fopen( filename, "r" );
	preprocess_file(originalFile, filename);
}
