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
	int palabras_reservadas = 0;
	int identifiers = 0;
	int literals = 0;
	int operators = 0;
	int delimiters = 0;
	int token_total = 0;

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

%%
"<<=" {operators ++; token_total ++; strcpy(name,yytext); return SHLEQUAL;}
">>=" { operators ++; token_total ++;strcpy(name,yytext); return SHREQUAL;}
"++" { operators ++; token_total ++;strcpy(name,yytext); return PLUSPLUS;}
"--" { operators ++; token_total ++;strcpy(name,yytext); return MINUSMINUS;}
"+=" { operators ++; token_total ++;strcpy(name,yytext); return PLUSEQUAL;}
"-=" { operators ++; token_total ++;strcpy(name,yytext); return MINUSEQUAL;}
"*=" { operators ++; token_total ++;strcpy(name,yytext); return MULEQUAL;}
"/=" { operators ++; token_total ++;strcpy(name,yytext); return DIVEQUAL;}
"%=" { operators ++; token_total ++;strcpy(name,yytext); return MODEQUAL;}
"&=" { operators ++; token_total ++;strcpy(name,yytext); return ANDEQUAL;}
"|=" { operators ++; token_total ++;strcpy(name,yytext); return OREQUAL;}
"^="  { operators ++; token_total ++;strcpy(name,yytext); return ROOFEQUAL;}
"->" { operators ++; token_total ++;strcpy(name,yytext); return ARROW;}
"==" { operators ++; token_total ++;strcpy(name,yytext); return EQUAL;}
"!=" { operators ++; token_total ++;strcpy(name,yytext); return NOTEQUAL;}
"&&" { operators ++; token_total ++;strcpy(name,yytext); return AND;}
"||" { operators ++; token_total ++;strcpy(name,yytext); return OR;}
"<<" { operators ++; token_total ++;strcpy(name,yytext); return SHL;}
">>" { operators ++; token_total ++;strcpy(name,yytext); return SHR;}
"<=" { operators ++; token_total ++;strcpy(name,yytext); return LEQ; }
">=" { operators ++; token_total ++;strcpy(name,yytext); return GEQ;}
"<>" { operators ++; token_total ++;strcpy(name,yytext); return LESSMORE;}
"=" { operators ++; token_total ++;strcpy(name,yytext); return ASSIGN;}
"+" { operators ++; token_total ++;strcpy(name,yytext); return PLUS;   }
"-" { operators ++; token_total ++;strcpy(name,yytext); return MINUS; }
"*" { operators ++; token_total ++;strcpy(name,yytext); return MUL; }
"/" { operators ++; token_total ++;strcpy(name,yytext); return DIV; }
"&" { operators ++; token_total ++;strcpy(name,yytext); return BITAND;}
"|" { operators ++; token_total ++;strcpy(name,yytext); return BITOR;}
"^" { operators ++; token_total ++;strcpy(name,yytext); return ROOF;}
"~" { operators ++; token_total ++;strcpy(name,yytext); return TAIL;}
"%" { operators ++; token_total ++;strcpy(name,yytext); return MOD;}
"<" { operators ++; token_total ++;strcpy(name,yytext); return LESS;}
">" { operators ++; token_total ++;strcpy(name,yytext); return GREATER;}
{string} { strcpy(name,yytext); return STRING;}
"_" { strcpy(name,yytext); return UNDERSCORE;}

"'" { strcpy(name,yytext); return SINGLEQUOTE;}
"(" { delimiters ++; token_total ++;strcpy(name,yytext); return LPAREN;}
")" { delimiters ++; token_total ++;strcpy(name,yytext); return RPAREN;}
"{" { delimiters ++; token_total ++;strcpy(name,yytext); return CORCHL;}
"}" { delimiters ++; token_total ++;strcpy(name,yytext); return CORCHR;}
"[" { delimiters ++; token_total ++;strcpy(name,yytext); return LBRACKET;}
"]" { delimiters ++; token_total ++;strcpy(name,yytext); return RBRACKET;}
"\\" { strcpy(name,yytext); return BACKSLASH;}
"/*" { strcpy(name,yytext);return COMMENTOPEN;}
"*/" { strcpy(name,yytext);return COMMENTCLOSE;}
"//" { strcpy(name,yytext);return UNCLOSEDCOMMENT;}

":" { delimiters ++; token_total ++;strcpy(name,yytext); return COLON;}
"?" { strcpy(name,yytext); return QUESTIONMARK;}
"!" { operators++; token_total ++; strcpy(name,yytext); return NOT;}
";" { delimiters ++; token_total ++;strcpy(name,yytext); return SEMICOLON;}
"," { delimiters ++; token_total ++;strcpy(name,yytext); return COMMA;}
"." { delimiters ++; token_total ++;strcpy(name,yytext); return PERIOD;}
"\"" { strcpy(name,yytext); return DOUBLEQUOTE;}

"if" { palabras_reservadas ++; token_total ++;strcpy(name,yytext); return IFSYS; }
"else" { palabras_reservadas ++; token_total ++;strcpy(name,yytext); return ELSESYS;}
"while" { palabras_reservadas ++; token_total ++;strcpy(name,yytext); return WHILELOOP;}
"for" { palabras_reservadas ++; token_total ++;strcpy(name,yytext); return FORLOOP;}
"auto" { palabras_reservadas ++; token_total ++; strcpy(name,yytext); return AUTO;}
"break" { palabras_reservadas ++; token_total ++; strcpy(name,yytext); return BREAK;}
"case" { palabras_reservadas ++; token_total ++; strcpy(name,yytext); return CASE;}
"char" { palabras_reservadas ++; token_total ++; strcpy(name,yytext); return CHAR;}
"const" { palabras_reservadas ++; token_total ++; strcpy(name,yytext); return CONST;}
"continue" { palabras_reservadas ++; token_total ++;strcpy(name,yytext); return CONTINUE;}

"default" { palabras_reservadas ++; token_total ++; strcpy(name,yytext); return DEFAULT;}
"do" { palabras_reservadas ++; token_total ++;strcpy(name,yytext); return DO;}
"double" { palabras_reservadas ++; token_total ++;strcpy(name,yytext); return DOUBLE;}
"enum" { palabras_reservadas ++; token_total ++;strcpy(name,yytext); return ENUM;}
"extern" { palabras_reservadas ++; token_total ++;strcpy(name,yytext); return EXTERN;}
"float" { palabras_reservadas ++; token_total ++; strcpy(name,yytext); return FLOAT;}
"goto" { palabras_reservadas ++; token_total ++; strcpy(name,yytext); return GOTO;}
"int" { palabras_reservadas ++; token_total ++; strcpy(name,yytext); return INT;}


"printf" { palabras_reservadas ++; token_total ++; strcpy(name,yytext); return PRINTF;}
"fprintf" {palabras_reservadas ++; token_total ++; strcpy(name,yytext); return FPRINTF;}
"fopen" {palabras_reservadas ++; token_total ++; strcpy(name,yytext); return FOPEN;}
"fclose" {palabras_reservadas ++; token_total ++; strcpy(name,yytext); return FCLOSE;}
"system" {palabras_reservadas ++; token_total ++; strcpy(name,yytext); return SYSTEM;}
"strcpy" {palabras_reservadas ++; token_total ++; strcpy(name,yytext); return STRCPY;}
"strcmp" {palabras_reservadas ++; token_total ++; strcpy(name,yytext); return STRCMP;}
"exit" {palabras_reservadas ++; token_total ++; strcpy(name,yytext); return EXIT;}
"true" {palabras_reservadas ++; token_total ++; strcpy(name,yytext); return TRUE;}
"false" {palabras_reservadas ++; token_total ++; strcpy(name,yytext); return FALSE;}
"toupper" {palabras_reservadas ++; token_total ++; strcpy(name,yytext); return TOUPPER;}
"feof" {palabras_reservadas ++; token_total ++; strcpy(name,yytext); return FEOF;}
"getc" {palabras_reservadas ++; token_total ++; strcpy(name,yytext); return GETC;}
"memset" {palabras_reservadas ++; token_total ++; strcpy(name,yytext); return MEMSET;}
"malloc" {palabras_reservadas ++; token_total ++; strcpy(name,yytext); return MALLOC;}
"calloc" {palabras_reservadas ++; token_total ++; strcpy(name,yytext); return CALLOC;}


"long" { palabras_reservadas ++; token_total ++;strcpy(name,yytext); return LONG;}
"register" { palabras_reservadas ++; token_total ++; strcpy(name,yytext); return REGISTER;}
"return" { palabras_reservadas ++; token_total ++; return RETURN;}
"short" { palabras_reservadas ++; token_total ++; strcpy(name,yytext); return SHORT;}
"signed" { palabras_reservadas ++; token_total ++; strcpy(name,yytext); return SIGNED;}
"sizeof" { palabras_reservadas ++; token_total ++; strcpy(name,yytext); return SIZEOF;}
"static" { palabras_reservadas ++; token_total ++;strcpy(name,yytext); return STATIC;}
"struct" { palabras_reservadas ++; token_total ++;strcpy(name,yytext); return STRUCT;}
"switch" { palabras_reservadas ++; token_total ++;strcpy(name,yytext); return SWITCH;}
"typedef" { palabras_reservadas ++; token_total ++;strcpy(name,yytext); return TYPEDEF;}
"union" { palabras_reservadas ++; token_total ++; strcpy(name,yytext); return UNION;}
"unsigned" { palabras_reservadas ++; token_total ++; strcpy(name,yytext); return UNSIGNED;}
"void" { palabras_reservadas ++; token_total ++; strcpy(name,yytext); return VOID;}
"volatile" { palabras_reservadas ++; token_total ++;strcpy(name,yytext); return VOLATILE;}

 <<EOF>> { strcpy(name,yytext); return EOF;}
 [\t] 	{strcpy(name,yytext); return TAB;}
 " " { strcpy(name,yytext); return SPACE;}
[\n]	{strcpy(name,yytext); return NEWLINE;}

{letter}({letter}|{number}|{number})* { identifiers ++; token_total ++; strcpy(name,yytext); return ID;}
{number}+ { literals ++; token_total ++; strcpy(name,yytext); return NUMBER;}
.	{ strcpy(name,yytext); return UNKNOWN;}




%%
	/* --------------------------------------------------------------------------------------------------Code */

	void checkRegisteredTokens(){
		printf("PALABRAS RESERVADAS ---> %d\n", palabras_reservadas);
		printf("IDENTIFICADORES ---> %d\n", identifiers);
		printf("LITERALS ---> %d\n", literals);
		printf("OPERADORES ---> %d\n", operators);
		printf("DELIMITADORES ---> %d\n", delimiters);
		printf("token_total ---> %d\n", token_total);
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

void toHex(FILE* file) {
	char outword[33];
	int i,len;
	len = strlen(yytext);
	for(i = 0; i<len; i++) {
		sprintf(outword + i * 2, "%02X", yytext[i]);
	}
	fprintf(file, " \\textcolor{Red}{%s}\n",  outword);
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





	  fprintf(beamerFile, "\\documentclass[8, usernames, dvipsnames]{beamer}\n");
		fprintf(beamerFile, "\\usepackage{color}\n");

		fprintf(beamerFile, "\\usepackage{pgfplots}\n");
		fprintf(beamerFile, "\\pgfplotsset{width=11.5cm,compat=1.9}\n");
		fprintf(beamerFile, "\\usepackage{dirtytalk}\n");
		fprintf(beamerFile, "\\usepackage[spanish]{babel}\n");
		fprintf(beamerFile, "\\usepackage[utf8]{inputenc}\n");

		fprintf(beamerFile, "\\usepackage{pgf-pie}\n");

		fprintf(beamerFile, "\\usetheme{Warsaw}\n");
		fprintf(beamerFile, "\\usecolortheme{spruce}\n");

	  fprintf(beamerFile, "\\setbeamercolor{itemize item}{fg=darkred!80!black}\n");




	  fprintf(beamerFile,"\\begin{document} \n");
	  fprintf(beamerFile, "\\title{\n");
		fprintf(beamerFile, "\\begin{Large}\n");
		fprintf(beamerFile, "TEC\n");
		fprintf(beamerFile, "\\end{Large}\n");
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
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "SeaGreen", t.value);
					break;
				//Operadores Lógicos
				case AND:
					fprintf(beamerFile, "\\textcolor{%s}{ \\%c\\%c }\n", "Goldenrod", yytext[0], yytext[1]);
					break;
				case OR:
					fprintf(beamerFile, "\\textcolor{%s}{ $%s$ }\n", "Goldenrod", t.value);
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

				case FPRINTF:
				case PRINTF:
				case FOPEN:
				case FCLOSE:
				case MALLOC:
				case SYSTEM:
				case CALLOC:
				case STRCPY:
				case STRCMP:
				case EXIT:
				case TRUE:
				case FALSE:
				case TOUPPER:
				case FEOF:
				case GETC:
				case MEMSET:
					fprintf(beamerFile, "\\textcolor{%s}{%s}\n", "OrangeRed", t.value);
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
				case MOD:
					fprintf(beamerFile, "\\textcolor{%s}{\\%s}\n", "Apricot", t.value);
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
						fprintf(beamerFile, "\\textcolor{%s}{\\lq ", "BrickRed");
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
					case UNKNOWN:
						toHex(beamerFile);
						break;

				}
				t = getNextToken(bufferFinal);
		}
		fprintf(beamerFile, "\\end{frame}\n");

		//*************************Histograma**************************************





		fprintf(beamerFile,"\\begin{frame} \n");

		fprintf(beamerFile,"\\begin{tikzpicture} \n");
		fprintf(beamerFile,"\\begin{axis}[ \n");

		fprintf(beamerFile,"symbolic x coords={Reservadas, Identificadores,Literales,Operadores, Delimitadores},xtick=data,xticklabel style={anchor=base,yshift=-\\baselineskip},\n");
		fprintf(beamerFile,"nodes near coords={\\pgfmathprintnumber\\pgfplotspointmeta}\n");



		fprintf(beamerFile,"]\n");

		fprintf(beamerFile,"\\addplot[ybar,fill=Turquoise]  \n");
		fprintf(beamerFile,"coordinates {\n");

		fprintf(beamerFile, "(%s,", "Reservadas");
		fprintf(beamerFile, "%d)", palabras_reservadas);
		fprintf(beamerFile, "(%s,", "Identificadores");
		fprintf(beamerFile, "%d)",identifiers);
		fprintf(beamerFile, "(%s,", "Literales");
		fprintf(beamerFile, "%d)", literals);
		fprintf(beamerFile, "(%s,", "Operadores");
		fprintf(beamerFile, "%d)", operators);
		fprintf(beamerFile, "(%s,", "Delimitadores");
		fprintf(beamerFile, "%d)", delimiters);
		fprintf(beamerFile,"};\n");


		fprintf(beamerFile,"\\end{axis}\n");
		fprintf(beamerFile,"\\end{tikzpicture}\n");
		fprintf(beamerFile,"\\end{frame} \n");

		//************************Pie

		fprintf(beamerFile,"\\begin{frame} \n");

		fprintf(beamerFile,"\\begin{tikzpicture}\n");
		fprintf(beamerFile,"\\pie[rotate = 180]\n");
		fprintf(beamerFile,"{%.2lf",(100 * palabras_reservadas)/((double)token_total));
		fprintf(beamerFile,"/Palabras Reservadas,\n");
		fprintf(beamerFile,"%.2lf",(100 * identifiers)/((double)token_total));
		fprintf(beamerFile,"/Identificadores,\n");
		fprintf(beamerFile,"%.2lf",(100 * literals)/((double)token_total));
		fprintf(beamerFile,"/Literales,\n");
		fprintf(beamerFile,"%.2lf",(100 * operators)/((double)token_total));
		fprintf(beamerFile,"/Operadores,\n");
		fprintf(beamerFile,"%.2lf",(100 * delimiters)/((double)token_total));
		fprintf(beamerFile,"/Delimitadores}\n");


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
		if(next_token == UNCLOSEDCOMMENT){
			while(next_token != NEWLINE){
				next_token = yylex();
			}
			next_token = yylex();
		}
		estructura identifiedToken;
		identifiedToken.token_type = next_token;
		strcpy(identifiedToken.value,name);

		printf("%s", identifiedToken.value);
		return identifiedToken;
	}
