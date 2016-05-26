#ifndef GLOBAL_H
#define GLOBAL_H
#endif

/*--Definicion de variables-----------------------------------------------------------------------------------------------*/
FILE *file;
int token_type[105];
int token_quantity[105];



/*--------------------------------------------Contiene todos los datos globales---------------------------------------*/
/*Representa el conjunto de tipos de tokens*/
typedef enum token_types{
  PLUS, MUL, MINUS, IFSYS, ELSESYS, LPAREN, RPAREN, EQUAL, ASSIGN, CORCHL, CORCHR, SEMICOLON, ID, NUMBER, STRING, DOUBLEQUOTE, LESSMORE,
	WHILELOOP, FORLOOP, LEQ, GEQ,LESS,GREATER,COMMA,PERIOD,UNKNOWN,INCLUDE, DEFINE, FILENAME,QUOTES,LIBRARY,VALUE,
	CODIGO,SPACE,NEWLINE,VARIABLE, QUOTATION, TAB,CASE,CHAR,CONST,CONTINUE,DEFAULT, DO,DOUBLE,ENUM,EXTERN,FLOAT,GOTO,INT, LONG, REGISTER, RETURN,SHORT, BACKSLASH,
	SIGNED, SIZEOF, STATIC,STRUCT,SWITCH,TYPEDEF,UNION, UNSIGNED, VOID, VOLATILE, NOTEQUAL, ARROW, QUESTIONMARK, COLON, AND, OR, DIV, AUTO, BREAK, NOT,
	PLUSPLUS, MINUSMINUS, PLUSEQUAL, MINUSEQUAL, MULEQUAL, DIVEQUAL, MODEQUAL, SHLEQUAL, SHREQUAL, ANDEQUAL, OREQUAL, ROOFEQUAL, BITAND, BITOR, ROOF, TAIL,
	LBRACKET, RBRACKET, SHL, SHR, MOD,  SINGLEQUOTE, COMMENTOPEN, COMMENTCLOSE, UNDERSCORE, CHARACTER, PRINTF,
  FPRINTF, FOPEN,FCLOSE, SYSTEM, STRCPY,STRCMP,EXIT, TRUE, FALSE, TOUPPER, FEOF, GETC, MEMSET, MALLOC, CALLOC, UNCLOSEDCOMMENT, PRINTSTRING
} token;
/*------------------------------------------------------------------------------------------------------------------------*/
typedef enum {false=0, true=1} bool;

typedef struct estructura{
  int token_type;
  char value[512];
} estructura;


void open_file();
void openFilePath(YY_BUFFER_STATE buffer,FILE *output);
void readIncludeFile(FILE *file, FILE *output);
void check_all_tokens(YY_BUFFER_STATE buffer);
void clear_includedFilesList();
void preprocess_file(FILE *originalFile, char* filename);
void add_includedFile(char* filename);
bool isIncluded(char* filename);

estructura getNextToken();
void clear_token_buffer();
void count_tokens(int pToken);
bool isInserted(int pTokenType);
void insertTokenType(int pTokenType);
void checkRegisteredTokens();
void getTokenName(int tkn_type, char * to_filled);
