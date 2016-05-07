/* 
 * Description: Recognize the 32-bit hexadecimal integer from stdin
 * Pattern: 0[xX]([0-9a-fA-F]{1,8})
 */

digit		[0-9]
alpha		[a-fA-F]+
hextail		({digit}|{alpha}){1,8}
hex		0[xX]{hextail}

%%
{hex}	printf("Found a HEX number %s !", yytext);
{alpha} printf("Estas son letras \n");
{digit} printf("Estos son numeros\n");

%%

main()
{
  printf("Give me your input:\n");
  yylex();
}