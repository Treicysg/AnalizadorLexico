%option yylineno
%option header-file = "prep_scanner.h"
%option outfile = "prep_scanner.c"
%option noyywrap
%{
	#include <stdio.h>
	#include <ctype.h>
	#include "global.h"
	char name[512] = "";
	int insertedTokens = 0;

%}

D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS		(f|F|l|L)
IS		(u|U|l|L)*

  /* ------------------------------------------------------------------------------------------------ Rules */


number         [0-9]
letter        [a-zA-Z]
under 		  "_"
string 		\"(\\.|[^"])*\"
char 		\'(\\.|[^"])*\'
%%

"<<=" { strcpy(name,yytext); return SHLEQUAL;}
">>=" { strcpy(name,yytext); return SHREQUAL;}
"++" { strcpy(name,yytext); return PLUSPLUS;}
"--" { strcpy(name,yytext); return MINUSMINUS;}
"+=" { strcpy(name,yytext); return PLUSEQUAL;}
"-=" { strcpy(name,yytext); return MINUSEQUAL;}
"*=" { strcpy(name,yytext); return MULEQUAL;}
"/=" { strcpy(name,yytext); return DIVEQUAL;}
"%=" { strcpy(name,yytext); return MODEQUAL;}
"&=" { strcpy(name,yytext); return ANDEQUAL;}
"|=" { strcpy(name,yytext); return OREQUAL;}
"^="  { strcpy(name,yytext); return ROOFEQUAL;}
"->" { strcpy(name,yytext); return ARROW;}
"==" { strcpy(name,yytext); return EQUAL;}
"!=" { strcpy(name,yytext); return NOTEQUAL;}
"&&" { strcpy(name,yytext); return AND;}
"||" { strcpy(name,yytext); return OR;}
"<<" { strcpy(name,yytext); return SHL;}
">>" { strcpy(name,yytext); return SHR;}
"<=" { strcpy(name,yytext); return LEQ; }
">=" { strcpy(name,yytext); return GEQ;}
"<>" { strcpy(name,yytext); return LESSMORE;}
"=" { strcpy(name,yytext); return ASSIGN;}
"+" { strcpy(name,yytext); return PLUS;   }
"-" { strcpy(name,yytext); return MINUS; }
"*" { strcpy(name,yytext); return MUL; }
"/" { strcpy(name,yytext); return DIV; }
"&" { strcpy(name,yytext); return BITAND;}
"|" { strcpy(name,yytext); return BITOR;}
"^" { strcpy(name,yytext); return ROOF;}
"~" { strcpy(name,yytext); return TAIL;}
"%" { strcpy(name,yytext); return MOD;}
"<" { strcpy(name,yytext); return LESS;}
">" { strcpy(name,yytext); return GREATER;}
{string} { strcpy(name,yytext); return STRING;}
{char} { strcpy(name,yytext); return CHARACTER;}
"_" { strcpy(name,yytext); return UNDERSCORE;}

"'" { strcpy(name,yytext); return SINGLEQUOTE;}
"(" { strcpy(name,yytext); return LPAREN;}
")" { strcpy(name,yytext); return RPAREN;}
"{" { strcpy(name,yytext); return CORCHL;}
"}" { strcpy(name,yytext); return CORCHR;}
"[" { strcpy(name,yytext); return LBRACKET;}
"]" { strcpy(name,yytext); return RBRACKET;}
"\\" { strcpy(name,yytext); return BACKSLASH;}
"/*" { strcpy(name,yytext);return COMMENTOPEN;}
"*/" { strcpy(name,yytext);return COMMENTCLOSE;}

":" { strcpy(name,yytext); return COLON;}
"?" { strcpy(name,yytext); return QUESTIONMARK;}
"!" { strcpy(name,yytext); return NOT;}
";" { strcpy(name,yytext); return SEMICOLON;}
"," { strcpy(name,yytext); return COMMA;}
"." { strcpy(name,yytext); return PERIOD;}
"\"" { strcpy(name,yytext); return DOUBLEQUOTE;}

"if" {strcpy(name,yytext); return IFSYS; }
"else" {strcpy(name,yytext); return ELSESYS;}
"while" {strcpy(name,yytext); return WHILELOOP;}
"for" {strcpy(name,yytext); return FORLOOP;}
"auto" { strcpy(name,yytext); return AUTO;}
"break" { strcpy(name,yytext); return BREAK;}
"case" { strcpy(name,yytext); return CASE;}
"char" { strcpy(name,yytext); return CHAR;}
"const" { strcpy(name,yytext); return CONST;}
"continue" {strcpy(name,yytext); return CONTINUE;}

"default" { strcpy(name,yytext); return DEFAULT;}
"do" {strcpy(name,yytext); return DO;}
"double" {strcpy(name,yytext); return DOUBLE;}
"enum" {strcpy(name,yytext); return ENUM;}
"extern" {strcpy(name,yytext); return EXTERN;}
"float" { strcpy(name,yytext); return FLOAT;}
"goto" { strcpy(name,yytext); return GOTO;}
"int" { strcpy(name,yytext); return INT;}

"long" {strcpy(name,yytext); return LONG;}
"register" { strcpy(name,yytext); return REGISTER;}
"return" { return RETURN;}
"short" { strcpy(name,yytext); return SHORT;}
"signed" { strcpy(name,yytext); return SIGNED;}
"sizeof" { strcpy(name,yytext); return SIZEOF;}
"static" {strcpy(name,yytext); return STATIC;}
"struct" {strcpy(name,yytext); return STRUCT;}
"switch" {strcpy(name,yytext); return SWITCH;}
"typedef" {strcpy(name,yytext); return TYPEDEF;}
"union" { strcpy(name,yytext); return UNION;}
"unsigned" { strcpy(name,yytext); return UNSIGNED;}
"void" { strcpy(name,yytext); return VOID;}
"volatile" {strcpy(name,yytext); return VOLATILE;}

 <<EOF>> { strcpy(name,yytext); return EOF;}
 [\t] 	{strcpy(name,yytext); return TAB;}
 " " { strcpy(name,yytext); return SPACE;}
[\n]	{strcpy(name,yytext); return NEWLINE;}

{letter}({letter}|{number}|{number})* { strcpy(name,yytext); return ID;}
{number}+ { strcpy(name,yytext); return NUMBER;}
.	{ strcpy(name,yytext); return UNKNOWN;}


%%
	/* --------------------------------------------------------------------------------------------------Code */

	void checkRegisteredTokens(){
		int i;
		for(i=0; i < insertedTokens; i++){
			printf("token type = %d --> %d\n", token_type[i],token_quantity[i]);
		}
	}

	void count_tokens(int pToken){
		if (isInserted(pToken)){
		}
		else{
			insertTokenType(pToken);
		}
	}

	bool isInserted(int pTokenType){
		int i = 0;
		bool isInserted = false;
		while(i<105){
			if(pTokenType == token_type[i]){
				isInserted = true;
				token_quantity[i] ++; 	//Actualizo la cantidad de types registrados
			}
			i++;
		}
		return isInserted;
	}

	void insertTokenType(int pTokenType){

		token_type[insertedTokens] = pTokenType;
		token_quantity[insertedTokens] ++;
		insertedTokens++;

	}

	void scanFile(){
		file = fopen( "processedFile.txt", "r" );
		YY_BUFFER_STATE bufferFinal = yy_create_buffer(file,YY_BUF_SIZE);
		estructura t ;


		//Presentación Beamer. Parte 1

		FILE* beamerFile = fopen( "beamerFile.tex", "w+" );
		int slide_lines = 0;
	  /*fprintf(beamerFile,"\\documentclass[pdflatex,compress]{beamer} \n");
	  fprintf(beamerFile, "\\usetheme{Dresden}\n");
	  fprintf(beamerFile, "\\usecolortheme{whale}\n");
	  fprintf(beamerFile, "\\setbeamercolor{itemize item}{fg=darkred!80!black}\n");*/

	  fprintf(beamerFile, "\\documentclass[10, usernames, dvipsnames]{beamer}\n");
		fprintf(beamerFile, "\\usepackage{color}\n");
		fprintf(beamerFile, "\\usepackage[spanish]{babel}\n");
		//fprintf(beamerFile, "\\setbeamercolor{normal text}{bg=white!80}\n");
	  fprintf(beamerFile, "\\setbeamercolor{itemize item}{fg=darkred!80!black}\n");
	  fprintf(beamerFile,"\\begin{document} \n");
	  fprintf(beamerFile, "\\title{\n");
		fprintf(beamerFile, "\\begin{LARGE}\n");
		fprintf(beamerFile, "Instituto Tecnol\\'ogico de Costa Rica\n");
		fprintf(beamerFile, "\\end{LARGE}\n");
		fprintf(beamerFile, "\\newline\n");
		fprintf(beamerFile, "\\begin{Large}\n");
		fprintf(beamerFile, "\\\\Compiladores e Int\\'erpretes\n");
		fprintf(beamerFile, "\\\\Proyecto \\#2: Analizador L\\'exico\n");
		fprintf(beamerFile, "\\\\Profesor: Francisco Torres\n");
		fprintf(beamerFile, "\\end{Large}\n");
	  fprintf(beamerFile, "}\n");
	  fprintf(beamerFile, "\\author{Dennisse Rojas Casanova\n");
	  fprintf(beamerFile, "\\\\Treicy S\\'anchez Guti\\'errez}\n");
		fprintf(beamerFile, "\\date{25 de Mayo, 2016}\n");
	  fprintf(beamerFile,"\\maketitle \n");

		//Parte 1 :Flex y Scanner
	  fprintf(beamerFile,"\\begin{frame} \n");
	  fprintf(beamerFile,"\\frametitle{An\\'alisis L\\'exico y Flex} \n");
	  fprintf(beamerFile,"El An\\'alisis L\\'exico consiste en descomponer un fuente de entrada en categor\\'ias l\\'exicas m\\'inimas llamadas tokens.");
	  fprintf(beamerFile,"Un programa en Flex consiste b\\'asicamente en una lista de expresiones regulares que definen acciones a ejecutar cuando ocurre un match.");
	  fprintf(beamerFile,"\\end{frame} \n");
		fprintf(beamerFile, "\\begin{frame}\n");

		t = getNextToken(bufferFinal);
		while(t.token_type != EOF){
			if(slide_lines == 10) {
			fprintf(beamerFile, "\\end{frame}\n");
			fprintf(beamerFile, "\\begin{frame}\n");
			slide_lines = 0;
			}
			switch(t.token_type){
				case NUMBER:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "BurntOrange", t.value);
					break;

				}
				t = getNextToken(bufferFinal);
		}

		//Final del Archivo
		fprintf(beamerFile, "\\end{frame}\n");
		fprintf(beamerFile,"\\end{document}");
		fclose(beamerFile);
		system("pdflatex beamerFile.tex");
		system("evince beamerFile.pdf");

	}

	estructura getNextToken(YY_BUFFER_STATE buffer){
		yy_switch_to_buffer (buffer); // Nos pasamos al buffer principal.
		int next_token = yylex();
		if (next_token == COMMENTOPEN){
			printf("Encontre el inicio d un comment!\n");
			while(next_token != COMMENTCLOSE){
				next_token = yylex();
			}
			printf("Encontre el final del comment %s\n", name);
			next_token = yylex();
		}
		estructura identifiedToken;
		identifiedToken.token_type = next_token;
		strcpy(identifiedToken.value,name);

		printf("%s", identifiedToken.value);
		count_tokens(identifiedToken.token_type);
		return identifiedToken;
	}
