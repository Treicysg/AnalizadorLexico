%{
	#include <stdio.h>
	#include <ctype.h>
	#include "global.h"
	char name[1024] = "";
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
{number}+             { strcpy(name,yytext); return NUMBER;}
.	{ strcpy(name,yytext); return UNKNOWN;}


%%
	/* --------------------------------------------------------------------------------------------------Code */
	main(int argc,char *argv){
		char filename [100]="";
		printf( "Ingrese el archivo ya preprocesado: ");
		scanf("%s",filename);
		file = fopen( filename, "r" );
		YY_BUFFER_STATE bufferFinal = yy_create_buffer(file,YY_BUF_SIZE);
		getNextToken();
	}

	token getNextToken(YY_BUFFER_STATE buffer){
		printf("holaaa");
		yy_switch_to_buffer (buffer); // Nos pasamos al buffer principal.
		int next_token;
		while((next_token= yylex())!= EOF){
			if(next_token == PLUS){
				printf("PLUS = %s\n", name);
			}
			else if(next_token == MUL){
				printf("MUL = %s\n", name);
			}
			else if(next_token == MINUS){
				printf("MINUS = %s\n", name);
			}
			else if(next_token == IFSYS){
				printf("IFSYS = %s\n", name);
			}
			else if(next_token == ELSESYS){
				printf("ELSESYS = %s\n", name);
			}
			else if(next_token ==  ASSIGN){
				printf(" ASSIGN = %s\n", name);
			}
			else if(next_token == CORCHL){
				printf("CORCHL = %s\n", name);
			}
			else if(next_token == CORCHR){
				printf("CORCHR = %s\n", name);
			}
			else if(next_token == SEMICOLON){
				printf("SEMICOLON = %s\n", name);
			}
			else if(next_token == ID){
				printf("ID = %s\n", name);
			}
			else if(next_token == NUMBER){
				printf("NUMBER = %s\n", name);
			}
			else if(next_token == STRING){
				printf("STRING = %s\n", name);
			}
			else if(next_token == DOUBLEQUOTE){
				printf("DOUBLEQUOTE = %s\n", name);
			}
			else if(next_token == LESSMORE){
				printf("LESSMORE = %s\n", name);
			}

			else if(next_token == WHILELOOP){
				printf("WHILELOOP = %s\n", name);
			}
			else if(next_token == FORLOOP){
				printf("FORLOOP = %s\n", name);
			}
			else if(next_token == LEQ){
				printf("LEQ = %s\n", name);
			}
			else if(next_token == GEQ){
				printf("GEQ = %s\n", name);
			}
			else if(next_token == LESS){
				printf("LESS = %s\n", name);
			}
			else if(next_token == GREATER){
				printf("GREATER = %s\n", name);
			}
			else if(next_token == COMMA){
				printf("COMMA = %s\n", name);
			}
			else if(next_token == PERIOD){
				printf("PERIOD = %s\n", name);
			}
			else if(next_token == UNKNOWN){
				printf("UNKNOWN = %s\n", name);
			}
			else if(next_token == INCLUDE){
				printf("INCLUDE = %s\n", name);
			}
			else if(next_token == DEFINE){
				printf("DEFINE = %s\n", name);
			}
			else if(next_token == FILENAME){
				printf("FILENAME = %s\n", name);
			}

			else if(next_token == QUOTES){
				printf("QUOTES = %s\n", name);
			}
			else if(next_token == LIBRARY){
				printf("LIBRARY = %s\n", name);
			}
			else if(next_token == VALUE){
				printf("VALUE = %s\n", name);
			}
			else if(next_token == CODIGO){
				printf("CODIGO = %s\n", name);
			}
			else if(next_token == SPACE){
				printf("SPACE = %s\n", name);
			}
			else if(next_token == NEWLINE){
				printf("NEWLINE = %s\n", name);
			}
			else if(next_token == VARIABLE){
				printf("VARIABLE = %s\n", name);
			}
			else if(next_token == QUOTATION){
				printf("QUOTATION = %s\n", name);
			}
			else if(next_token == TAB){
				printf("TAB = %s\n", name);
			}
			else if(next_token == CASE){
				printf("CASE = %s\n", name);
			}
			else if(next_token == CHAR){
				printf("CHAR = %s\n", name);
			}
			else if(next_token == CONST){
				printf("CONST = %s\n", name);
			}
			else if(next_token == CONTINUE){
				printf("CONTINUE = %s\n", name);
			}
			else if(next_token == DEFAULT){
				printf("DEFAULT = %s\n", name);
			}
			else if(next_token == DO){
				printf("DO = %s\n", name);
			}
			else if(next_token == DOUBLE){
				printf("DOUBLE = %s\n", name);
			}
			else if(next_token == ENUM){
				printf("ENUM = %s\n", name);
			}
			else if(next_token == EXTERN){
				printf("EXTERN = %s\n", name);
			}
			else if(next_token == FLOAT){
				printf("FLOAT = %s\n", name);
			}
			else if(next_token == GOTO){
				printf("GOTO = %s\n", name);
			}
			else if(next_token == INT){
				printf("INT = %s\n", name);
			}
			else if(next_token == LONG){
				printf("LONG = %s\n", name);
			}
			else if(next_token == REGISTER){
				printf("REGISTER = %s\n", name);
			}
			else if(next_token == RETURN){
				printf("RETURN = %s\n", name);
			}
			else if(next_token == SHORT){
				printf("SHORT = %s\n", name);
			}
			else if(next_token == BACKSLASH){
				printf("BACKSLASH = %s\n", name);
			}
			else if(next_token == SIGNED){
				printf("SIGNED = %s\n", name);
			}
			else if(next_token == SIZEOF){
				printf("SIZEOF = %s\n", name);
			}
			else if(next_token == STATIC){
				printf("STATIC = %s\n", name);
			}
			else if(next_token == STRUCT){
				printf("STRUCT = %s\n", name);
			}
			else if(next_token == SWITCH){
				printf("SWITCH = %s\n", name);
			}
			else if(next_token == TYPEDEF){
				printf("TYPEDEF = %s\n", name);
			}
			else if(next_token == UNION){
				printf("UNION = %s\n", name);
			}
			else if(next_token == UNSIGNED){
				printf("UNSIGNED = %s\n", name);
			}
			else if(next_token == VOID){
				printf("VOID = %s\n", name);
			}
			else if(next_token == VOLATILE){
				printf("VOLATILE = %s\n", name);
			}
			else if(next_token == NOTEQUAL){
				printf("NOTEQUAL = %s\n", name);
			}
			else if(next_token == ARROW){
				printf("ARROW = %s\n", name);
			}
			else if(next_token == QUESTIONMARK){
				printf("QUESTIONMARK = %s\n", name);
			}
			else if(next_token == COLON){
				printf("COLON = %s\n", name);
			}
			else if(next_token == AND){
				printf("AND = %s\n", name);
			}
			else if(next_token == OR){
				printf("OR = %s\n", name);
			}
			else if(next_token == DIV){
				printf("DIV = %s\n", name);
			}
			else if(next_token == AUTO){
				printf("AUTO = %s\n", name);
			}
			else if(next_token == BREAK){
				printf("BREAK = %s\n", name);
			}
			else if(next_token == NOT){
				printf("NOT = %s\n", name);
			}
			else if(next_token == PLUSPLUS){
				printf("PLUSPLUS = %s\n", name);
			}
			else if(next_token == MINUSMINUS){
				printf("MINUSMINUS = %s\n", name);
			}
			else if(next_token == PLUSEQUAL){
				printf("PLUSEQUAL = %s\n", name);
			}
			else if(next_token == MINUSEQUAL){
				printf("MINUSEQUAL = %s\n", name);
			}
			else if(next_token == MULEQUAL){
				printf("MULEQUAL = %s\n", name);
			}
			else if(next_token == DIVEQUAL){
				printf("DIVEQUAL = %s\n", name);
			}
			else if(next_token == MODEQUAL){
				printf("MODEQUAL = %s\n", name);
			}
			else if(next_token == SHLEQUAL){
				printf("SHLEQUAL = %s\n", name);
			}
			else if(next_token == SHREQUAL){
				printf("SHREQUAL = %s\n", name);
			}
			else if(next_token == ANDEQUAL){
				printf("ANDEQUAL = %s\n", name);
			}
			else if(next_token == OREQUAL){
				printf("OREQUAL = %s\n", name);
			}
			else if(next_token == ROOFEQUAL){
				printf("ROOFEQUAL = %s\n", name);
			}
			else if(next_token == BITAND){
				printf("BITAND = %s\n", name);
			}
			else if(next_token == BITOR){
				printf("BITOR = %s\n", name);
			}
			else if(next_token == ROOF){
				printf("ROOF = %s\n", name);
			}
			else if(next_token == TAIL){
				printf("TAIL = %s\n", name);
			}
			else if(next_token == LBRACKET){
				printf("LBRACKET = %s\n", name);
			}
			else if(next_token == RBRACKET){
				printf("RBRACKET = %s\n", name);
			}
			else if(next_token == SHL){
				printf("SHL = %s\n", name);
			}
			else if(next_token == SHR){
				printf("SHR = %s\n", name);
			}
			else if(next_token == MOD){
				printf("MOD = %s\n", name);
			}
			else if(next_token == SINGLEQUOTE){
				printf("SINGLEQUOTE = %s\n", name);
			}
			else if(next_token == COMMENTOPEN){
				printf("COMMENTOPEN = %s\n", name);
			}
			else if(next_token == COMMENTCLOSE){
				printf("COMMENTCLOSE = %s\n", name);
			}
			else if(next_token == UNDERSCORE){
				printf("UNDERSCORE = %s\n", name);
			}
			else if(next_token == CHARACTER){
				printf("CHARACTER = %s\n", name);
			}
			else{
				printf("NO enconntre el token para este character: %s\n",name);
			}
		}
	}
