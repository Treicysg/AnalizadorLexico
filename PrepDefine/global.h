#ifndef GLOBAL_H
#define GLOBAL_H
#endif

/*--------------------------------------------Contiene todos los datos globales---------------------------------------*/

/*Representa el conjunto de tipos de tokens*/
typedef enum token_types{
  PLUS, MUL, MINUS, IFSYS, ELSESYS, LPAREN, RPAREN, EQUAL, ASSIGN, CORCHL, CORCHR, SEMICOLON, ID, NUMBER, STRING, DOUBLEQUOTE, LESSMORE,
	WHILELOOP, FORLOOP, LEQ, GEQ,LESS,GREATER,COMMA,PERIOD,UNKNOWN,INCLUDE, DEFINE, FILENAME,VALUE,
	CODIGO,SPACE,NEWLINE,VARIABLE, QUOTATION, TAB,CASE,CHAR,CONST,CONTINUE,DEFAULT, DO,DOUBLE,ENUM,EXTERN,FLOAT,GOTO,INT, LONG, REGISTER, RETURN,SHORT, BACKSLASH,
	SIGNED, SIZEOF, STATIC,STRUCT,SWITCH,TYPEDEF,UNION, UNSIGNED, VOID, VOLATILE, NOTEQUAL, ARROW, QUESTIONMARK, COLON, AND, OR, DIV, AUTO, BREAK, NOT,
	PLUSPLUS, MINUSMINUS, PLUSEQUAL, MINUSEQUAL, MULEQUAL, DIVEQUAL, MODEQUAL, SHLEQUAL, SHREQUAL, ANDEQUAL, OREQUAL, ROOFEQUAL, BITAND, BITOR, ROOF, TAIL,
	LBRACKET, RBRACKET, SHL, SHR, MOD,  SINGLEQUOTE, COMMENTOPEN, COMMENTCLOSE, UNDERSCORE, CHARACTER
} token;
/*------------------------------------------------------------------------------------------------------------------------*/
typedef enum {false=0, true=1} bool;

void openFilePath(YY_BUFFER_STATE buffer,FILE *output);
void readIncludeFile(FILE *file, FILE *output);
