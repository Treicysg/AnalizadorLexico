	/* ------------------------------------------------------------------------------------------------Definitions */

%{
	#include <stdio.h>
	#include <ctype.h>
	#include <string.h>
	#include "global.h"
	int includeCounter = 0;
	int defineCounter = 0;
	char name[1024] = "";
	#define MAXIDLEN 33
	typedef char string[MAXIDLEN];


%}

digit [0-9]
letter [a-zA-Z]
%%
  /* ------------------------------------------------------------------------------------------------ Rules */


#[ \t]*define {ECHO; printf("Encontre un define \n");strcpy(name,yytext); return DEFINE;}
[ \t] {strcpy(name, yytext); return SPACE;}
#[ \t]*include[ \t"]+ {includeCounter++; printf("Encontre un include \n"); return INCLUDE; }
[\n]	{strcpy(name,"");return NEWLINE;}
"/*" { return COMMENTOPEN;}
"*/" { return COMMENTCLOSE;}
"\"" {strcpy(name,yytext);return CODE;}
"\\n" {strcpy(name,yytext);  return CODE; }
"+" {strcpy(name,yytext);  return CODE; }
"-" {strcpy(name,yytext);     return CODE; }
"*" {strcpy(name,yytext);       return CODE;}
"if" {strcpy(name,yytext);    return CODE; }
"else" {strcpy(name,yytext);return CODE;  }
"(" {strcpy(name,yytext); return CODE;    }
")" {strcpy(name,yytext);    return CODE; }
"==" {strcpy(name,yytext); return CODE;   }
"=" {strcpy(name,yytext); return CODE;      }
"{" {strcpy(name,yytext);return CODE;     }
"}" {strcpy(name,yytext);return CODE;    }
";" {strcpy(name,yytext);  return CODE;}
"while" {strcpy(name,yytext); return CODE;}
"for" {strcpy(name,yytext);  return CODE;}
"<=" {strcpy(name,yytext);  return CODE;   }
">=" {strcpy(name,yytext);  return CODE;   }
"<" {strcpy(name,yytext);  return CODE;    }
">" {strcpy(name,yytext);return CODE;     }
"," {strcpy(name,yytext);  return CODE;    }
"." {strcpy(name,yytext);    return CODE;  }
{letter}({letter}|{digit})* {strcpy(name,yytext); return CODE;}
{digit}({digit})* {strcpy(name,yytext); return VALUE;}
. {strcpy(name,yytext);return CODE;}
[^ \t\n"]+   { strcpy(name,yytext);}





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

	int current_token = yylex();
	if(current_token == DEFINE ){
		string cname;
		string value;
		current_token = yylex(); //espacio
		yylex(); //nombre
		strcpy(cname,name);


		current_token = yylex();// espacio
		if(current_token == SPACE){
			printf("You are going for a good way!! Continue\n");
		}
		current_token = yylex();// espera encontrar un valor
		if(current_token == VALUE){
			printf("Lo que se espera que haya en el valor es: %s\n", name);
			strcpy(value,name);
		}

		if(current_token==NEWLINE){
			printf("I am here!");
		}

		printf("Nombre:%s\nValor:%s\n", cname,value);
	}

}

//void change value(FILE* fInput,char* nombre, char* valor){}

main(int argc,char *argv){
	yyin = fopen( "prueba.txt", "r" );
	//printf("Cantidad de includes: %d, Cantidad de defines: %d\n",includeCounter,defineCounter);
	//printf("El nombre del archivo: %s \n",name);
	//openFilePath();
	processDefine();
}
