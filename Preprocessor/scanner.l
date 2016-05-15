%{
	#include <stdio.h>
	#include <ctype.h>
	#include "global.h"
%}

D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS		(f|F|l|L)
IS		(u|U|l|L)*
%%
  /* ------------------------------------------------------------------------------------------------ Rules */


number         [0-9]
letter        [a-zA-Z]
under 		  "_"
string 		\"(\\.|[^"])*\"
char 		\'(\\.|[^"])*\'
%%

"<<=" { return SHLEQUAL;}
">>=" { return SHREQUAL;}
"++" { return PLUSPLUS;}
"--" { return MINUSMINUS;}
"+=" { return PLUSEQUAL;}
"-=" { return MINUSEQUAL;}
"*=" { return MULEQUAL;}
"/=" { return DIVEQUAL;}
"%=" { return MODEQUAL;}
"&=" { return ANDEQUAL;}
"|=" { return OREQUAL;}
"^="  { return ROOFEQUAL;}
"->" { return ARROW;}
"==" { return EQUAL;}
"!=" { return NOTEQUAL;}
"&&" { return AND;}
"||" { return OR;}
"<<" { return SHL;}
">>" { return SHR;}
"<=" { return LEQ; }
">=" { return GEQ;}
"<>" { return LESSMORE;}
"=" { return ASSIGN;}
"+" { return PLUS;   }
"-" { return MINUS; }
"*" { return MUL; }
"/" { return DIV; }
"&" { return BITAND;}
"|" { return BITOR;}
"^" { return ROOF;}
"~" { return TAIL;}
"%" { return MOD;}
"<" { return LESS;}
">" { return GREATER;}
{string} { return STRING;}
{char} { return CHARACTER;}
"_" { return UNDERSCORE;}

"'" { return SINGLEQUOTE;}
"(" { return LPAREN;}
")" { return RPAREN;}
"{" { return CORCHL;}
"}" { return CORCHR;}
"[" { return LBRACKET;}
"]" { return RBRACKET;}
"\\" { return BACKSLASH;}

":" { return COLON;}
"?" { return QUESTIONMARK;}
"!" { return NOT;}
";" { return SEMICOLON;}
"," { return COMMA;}
"." { return PERIOD;}
"\"" { return DOUBLEQUOTE;}

"if" {return IFSYS; }
"else" {return ELSESYS;}
"while" {return WHILELOOP;}
"for" {return FORLOOP;}
"auto" { return AUTO;}
"break" { return BREAK;}
"case" { return CASE;}
"char" { return CHAR;}
"const" { return CONST;}
"continue" {return CONTINUE;}

"default" { return DEFAULT;}
"do" {return DO;}
"double" {return DOUBLE;}
"enum" {return ENUM;}
"extern" {return EXTERN;}
"float" { return FLOAT;}
"goto" { return GOTO;}
"int" { return INT;}

"long" {return LONG;}
"register" { return REGISTER;}
"return" { return RETURN;}
"short" { return SHORT;}
"signed" { return SIGNED;}
"sizeof" { return SIZEOF;}
"static" {return STATIC;}
"struct" {return STRUCT;}
"switch" {return SWITCH;}
"typedef" {return TYPEDEF;}
"union" { return UNION;}
"unsigned" { return UNSIGNED;}
"void" { return VOID;}
"volatile" {return VOLATILE;}

 <<EOF>> { return EOF;}
 [\t] 	{return TAB;}]
 " " { return SPACE;}
[\n]	{return NEWLINE;}

{letter}({letter}|{number}|{number})* { return ID;}
{number}+             { return NUMBER;}
.	{ return UNKNOWN;}


%%
	/* --------------------------------------------------------------------------------------------------Code */

  main(int argc,char *argv){
  	char filename [100]="";
  	printf( "Ingrese el archivo ya preprocesado: ");
  	scanf("%s",filename);
  	FILE *originalFile = fopen( filename, "r" );
  }
