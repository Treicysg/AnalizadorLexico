#include "global.h" /*datos globales*/
/*--Definicion de variables-----------------------------------------------------------------------------------------------*/
FILE *file;
int len, len_token_buffer, c, comment_char, filePos, charPos,len_tb;
char token_buffer[5];
char begin_buffer[5] = "BEGIN";
char end_buffer[3] = "END";
char read_buffer[4] = "READ";
char write_buffer[5] = "WRITE";
