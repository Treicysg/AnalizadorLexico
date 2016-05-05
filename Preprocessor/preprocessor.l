%{
	int includeCounter = 0;
	int defineCounter = 0;

%}

%%

"#define" {defineCounter++;}
"#include" {includeCounter++;}


%%

main(int argc,char **argv){
	
	yyin = fopen( "prueba.txt", "r" );
	yylex();
	printf("%d%d",includeCounter,defineCounter);
}