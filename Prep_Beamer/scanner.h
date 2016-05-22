#include "parcer.h"
void open_file(){
   char filename [100]="";
   printf( "Enter a value : ");
   scanf("%s",filename);
   file = fopen( filename, "r" );
}

void read_file(){
	open_file();
	if (file){
		len = ftell(file);
		//token_buffer= malloc(sizeof(char) *(len+1));
	}
	else{
		printf("Problema al abrir el archivo\n");
		exit(0);
	}

}


void close_file(){
	fclose(file);
}

void buffer_char(char c){
	token_buffer[charPos++] = c;
}

void clear_token_buffer(){
	memset(token_buffer, 0, 5);
	charPos = 0;
}

token check_reserved(){
	int letter, c;
	bool reserved;
	//Recorrer el token buffer, revisando su primera letra
	for(letter= 0; letter < len_tb; letter++){
		if ( 'B'== toupper(token_buffer[letter])){
			reserved = true;
			for(c = 0; c < 5; c++){
				if (begin_buffer[c] != toupper(token_buffer[letter++])){
					reserved = false;
					break;
				}
			}
			if(reserved == true){
				return BEGIN;
			}else{
				return ID;
			}

			break;
		}else if ('E' == toupper(token_buffer[letter])){
			reserved = true;
			for(c = 0; c < 3; c++){
				if (end_buffer[c] != toupper(token_buffer[letter++])){
					reserved = false;
					break;
				}
			}
			if(reserved == true){
				return END;
			}else{
				return ID;
			}
			break;
		}else if ('W' == toupper(token_buffer[letter])){
			reserved = true;
			for(c = 0; c < 5; c++){
				if (write_buffer[c] != toupper(token_buffer[letter++])){
					reserved = false;
					break;
				}
			}
			if(reserved == true){
				return WRITE;
			}else{
				return ID;
			}
			break;
		}else if ('R' == toupper(token_buffer[letter])){
			reserved = true;
			for(c = 0; c < 4; c++){
				if (read_buffer[c] != toupper(token_buffer[letter++])){
					reserved = false;
					break;
				}
			}
			if(reserved == true){
				return READ;
			}else{
				return ID;
			}
			break;
		}else{
			return ID;
		}
	}
}

void lexical_error(int character){
	printf("LEXICAL ERROR %d\n", character);
}
void print_token_buffer(){
	int i;
	printf("IMPRIMIENDO TOKEN BUFFER\n");
	//Prueba para ver que hay en el token_buffer.
	for (i = 0; i <=len_token_buffer; i++){
		printf("%d\n", token_buffer[i] );
	}
}

void get_tokens(){
	read_file();
	token ejemplo;
	while(filePos != len){
		ejemplo = scanner();
		printf("token %d\n", ejemplo );
	}

}
