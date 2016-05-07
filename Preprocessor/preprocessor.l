	/* ------------------------------------------------------------------------------------------------Definitions */

%{
	int includeCounter = 0;
	int defineCounter = 0;
	char str[999];

%}

%%
  /* ------------------------------------------------------------------------------------------------ Rules */
 
 
#[ \t]*define {defineCounter++; printf("Encontre un define \n");} 
#[ \t]*include[ \t]+ {includeCounter++; printf("Encontre un include \n");}
[^ \t\n]+   { getFilePath(yytext);}

     

%%
	/* --------------------------------------------------------------------------------------------------Code */
 
 
main(int argc,char *argv){
	
	yyin = fopen( "prueba.txt", "r" );
	yylex();
	printf("Cantidad de includes: %d, Cantidad de defines: %d\n",includeCounter,defineCounter);
}

void getFilePath(char *filepath)
{
	printf("Nombre del archivo: %s \n", filepath);
}