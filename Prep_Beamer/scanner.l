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
		int i;
		bool n_quote = true;
		int included_tokens = 0;
		int total_tkns = insertedTokens;



	  fprintf(beamerFile, "\\documentclass[10, usernames, dvipsnames]{beamer}\n");
		fprintf(beamerFile, "\\usepackage{color}\n");
		fprintf(beamerFile, "\\usepackage{pgfplots}\n");
		fprintf(beamerFile, "\\pgfplotsset{width=10cm,compat=1.9}\n");
		fprintf(beamerFile, "\\usepackage{dirtytalk}\n");
		fprintf(beamerFile, "\\usepackage[spanish]{babel}\n");
		fprintf(beamerFile, "\\usepackage[utf8]{inputenc}\n");
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
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "RedViolet", t.value);
					break;
				//Operadores Lógicos
				case AND:
					fprintf(beamerFile, "\\textcolor{%s}{ \\%c\\%c }\n", "Goldenrod", yytext[0], yytext[1]);
					break;
				case OR:
					fprintf(beamerFile, "\\textcolor{%s}{ $%s$ }\n", "Dandelion", t.value);
					break;
				case NOT:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "Goldenrod", t.value);
					break;

				//Operadores Aritméticos

				case PLUS:
				case MINUS:
				case MUL:
				case DIV:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "SpringGreen", t.value);
					break;

				case IFSYS:
				case ELSESYS:
				case WHILELOOP:
				case FORLOOP:
				case AUTO:
				case BREAK:
				case CASE:
				case CHAR:
				case CONST:
				case CONTINUE:
				case DEFAULT:
				case DO:
				case DOUBLE:
				case ENUM:
				case EXTERN:
				case FLOAT:
				case GOTO:
				case INT:
				case LONG:
				case REGISTER:
				case RETURN:
				case SHORT:
				case SIGNED:
				case SIZEOF:
				case STATIC:
				case STRUCT:
				case SWITCH:
				case TYPEDEF:
				case UNION:
				case UNSIGNED:
				case VOID:
				case VOLATILE:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "OrangeRed", t.value);
					break;

				case TAB:
					fprintf(beamerFile, "\\textcolor{%s}{\\%s }\n", "White", "  " );
					break;
				case SPACE:
					fprintf(beamerFile, "\\textcolor{%s}{\\ }\n", "White");
					break;
				case NEWLINE:
					fprintf(beamerFile, "\n ");
					slide_lines++;
					break;

				case COLON:
	 			case SEMICOLON:
	 			case COMMA:
	 			case PERIOD:
	 			case QUESTIONMARK:
	 				fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "Sepia", t.value);
	 				break;
	 			case UNDERSCORE:
	 				fprintf(beamerFile, "\\textcolor{%s}{\\%s}\n", "Sepia", t.value);
	 				break;

				case BACKSLASH:
					fprintf(beamerFile, "\\textcolor{%s}{%s }\n", "Gray", "\\textbackslash");
					break;
					case ASSIGN:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "Salmon", t.value);
					break;


				//PARENTHESES
				case LPAREN:
				case RPAREN:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "SkyBlue", t.value);
					break;
				case CORCHR:
				case CORCHL:
					fprintf(beamerFile, "\\textcolor{%s}{\\%s }\n", "SkyBlue", t.value);
					break;
				case LBRACKET:
				case RBRACKET:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "SkyBlue", t.value);
					break;

				case SINGLEQUOTE:
	 				fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "BurntOrange", t.value);
	 				break;
	 			case DOUBLEQUOTE:
	 				fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "BurntOrange", t.value);
	 				break;

				case SHLEQUAL:
				case SHREQUAL:
				case PLUSPLUS:
				case MINUSMINUS:
				case PLUSEQUAL:
				case MINUSEQUAL:
				case MULEQUAL:
				case DIVEQUAL:
				case MODEQUAL:
				case ANDEQUAL:
				case OREQUAL:
				case ROOFEQUAL:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "Apricot", t.value);
					break;
				case EQUAL:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "OliveGreen", "$==$");
					break;
				case NOTEQUAL:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "OliveGreen", "$!=$");
					break;
				case LEQ:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "OliveGreen", "\\textless =");
					break;
				case GEQ:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "OliveGreen", "\\textgreater =");
					break;
				case LESS:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "OliveGreen", "\\textless");
					break;
				case GREATER:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "OliveGreen", "\\textgreater");
					break;
				case LESSMORE:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "OliveGreen", "\\textless\\textgreater");
					break;


				case ARROW:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "Fuchsia", "-\\textgreater");
					break;
				case TAIL:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "MidnightBlue", "\\textasciitilde");
					break;
				case BITAND:
				case BITOR:
				case ROOF:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "MidnightBlue", "\\textasciicircum");
					break;
				case SHL:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "MidnightBlue", "\\textless\\textless");
					break;
				case SHR:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "MidnightBlue", "\\textgreater\\textgreater");
					break;

				case ID:

					i = 0;
					fprintf(beamerFile, "\\textcolor{%s}{", "Violet");
					while(i < yyleng) {
						if (yytext[i] == '_') {
							fprintf(beamerFile, "\\_");
						} else {
							fprintf(beamerFile, "%c", yytext[i]);
						}
						i++;
					}

					fprintf(beamerFile, "}");
					break;
				case STRING:
					n_quote = true;
					i = 1;
					fprintf(beamerFile, "\\textcolor{%s}{\\say{", "Orchid");
					while(n_quote) {

						if(yytext[i] == '"'){
							n_quote = false;
						} else if(yytext[i] == '|'){
							fprintf(beamerFile, " $\%c$ ", yytext[i]);
						} else if(yytext[i] == '{' || yytext[i] == '}' || yytext[i] == '%' || yytext[i] == '&' || yytext[i] == '#' || yytext[i] == '_') {
							fprintf(beamerFile, " \\%c ", yytext[i]);
						} else if(yytext[i] == '\\') {
							fprintf(beamerFile, " \\%s ", "textbackslash ");
						} else if(yytext[i] == '~') {
							fprintf(beamerFile, " \\%s ", "textasciitilde ");
						} else if(yytext[i] == '<') {
							fprintf(beamerFile, " \\%s ", "textless ");
						} else if(yytext[i] == '>') {
							fprintf(beamerFile, " \\%s ", "textgreater ");
						} else if(yytext[i] == '^') {
							fprintf(beamerFile, " \\%s ", "textasciicircum ");
						} else {
							fprintf(beamerFile, "%c", yytext[i]);
						}
						i++;
					}
					fprintf(beamerFile, "}}\n");
					break;
					case CHARACTER:
						n_quote = true;
						i = 1;
						fprintf(beamerFile, "\\textcolor{%s}{\\lq ", "Orchid");
						while(n_quote) {

							if(yytext[i] == '\''){
								n_quote = false;
							} else if(yytext[i] == '|'){
								fprintf(beamerFile, " $\%c$ ", yytext[i]);
							} else if(yytext[i] == '{' || yytext[i] == '}' || yytext[i] == '%' || yytext[i] == '&' || yytext[i] == '#' || yytext[i] == '_') {
								fprintf(beamerFile, " \\%c ", yytext[i]);
							} else if(yytext[i] == '\\') {
								fprintf(beamerFile, " \\%s ", "textbackslash");
							} else if(yytext[i] == '~') {
								fprintf(beamerFile, " \\%s ", "textasciitilde");
							} else if(yytext[i] == '<') {
								fprintf(beamerFile, " \\%s ", "textless");
							} else if(yytext[i] == '>') {
								fprintf(beamerFile, " \\%s ", "textgreater");
							} else if(yytext[i] == '^') {
								fprintf(beamerFile, " \\%s ", "textasciicircum");
							} else {
								fprintf(beamerFile, "%c", yytext[i]);
							}
							i++;
						}
						fprintf(beamerFile, "\\rq}\n");
						break;

				}
				t = getNextToken(bufferFinal);
		}
		fprintf(beamerFile, "\\end{frame}\n");

		//*************************Histograma**************************************





		fprintf(beamerFile,"\\begin{frame} \n");
		fprintf(beamerFile,"\\frametitle{Histograma} \n");
		fprintf(beamerFile,"\\begin{tikzpicture} \n");
		fprintf(beamerFile,"\\begin{axis}[ \n");
		fprintf(beamerFile,"x tick label style={\n");
		fprintf(beamerFile,"/pgf/number format/1000 sep=},\n");
		fprintf(beamerFile,"ylabel=Cantidad de Tokens,\n");
		fprintf(beamerFile,"enlargelimits=0.05,\n");
		fprintf(beamerFile,"legend style={at={(0.5,-0.1)},\n");
		fprintf(beamerFile,"anchor=north,legend columns=-1},\n");
		fprintf(beamerFile,"ybar interval=0.7,\n");
		fprintf(beamerFile,"]\n");

		fprintf(beamerFile,"\\addplot \n");
		fprintf(beamerFile,"coordinates {");
		for(i=0; i < insertedTokens; i++) {


			if(included_tokens == 5){
				  fprintf(beamerFile,"};\n");
					fprintf(beamerFile,"\\end{axis}\n");
					fprintf(beamerFile,"\\end{tikzpicture}\n");
					fprintf(beamerFile, "\\end{frame}\n");
					fprintf(beamerFile,"\\begin{frame} \n");
					fprintf(beamerFile,"\\begin{tikzpicture} \n");
					fprintf(beamerFile,"\\begin{axis}[ \n");
					fprintf(beamerFile,"x tick label style={\n");
					fprintf(beamerFile,"/pgf/number format/1000 sep=},\n");
					fprintf(beamerFile,"ylabel=Cantidad de Tokens,\n");
					fprintf(beamerFile,"enlargelimits=0.05,\n");
					fprintf(beamerFile,"legend style={at={(0.5,-0.1)},\n");
					fprintf(beamerFile,"anchor=north,legend columns=-1},\n");
					fprintf(beamerFile,"ybar interval=0.7,\n");
					fprintf(beamerFile,"]\n");

					fprintf(beamerFile,"\\addplot \n");
					fprintf(beamerFile,"coordinates {");
					included_tokens = 0;
			}

			fprintf(beamerFile, "(%d,", token_type[i]);
			fprintf(beamerFile, "%d)", token_quantity[i]);
			included_tokens+=1;


	 }


		fprintf(beamerFile,"};\n");
		fprintf(beamerFile,"\\end{axis}\n");
		fprintf(beamerFile,"\\end{tikzpicture}\n");
		fprintf(beamerFile,"\\end{frame} \n");





		//Final del Archivo

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
