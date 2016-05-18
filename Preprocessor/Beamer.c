#include <stdio.h>
#include <string.h> /* memset */
#include <stdlib.h>


int main( int argc, char *argv[] )
{
  FILE* beamerFile = fopen( "beamerFile.tex", "w+" );

  fprintf(beamerFile,"\\documentclass{beamer} newline",);
}
