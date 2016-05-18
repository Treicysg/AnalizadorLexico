#include <stdio.h>
#include <string.h> /* memset */
#include <stdlib.h>


void createBeamer()
{
  FILE* beamerFile = fopen( "beamerFile.tex", "w+" );
  fprintf(beamerFile,"\\documentclass{beamer} \n");
  fprintf(beamerFile,"\\title{A Tiny Example} \n");
  fprintf(beamerFile,"\\date{\\today}\n");
  fprintf(beamerFile,"\\begin{document} \n");
  fprintf(beamerFile,"\\maketitle \n");

  fprintf(beamerFile,"\\begin{frame} \n");
  fprintf(beamerFile,"\\frametitle{First Slide} \n");
  fprintf(beamerFile,"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. \n");
  fprintf(beamerFile,"\\end{frame} \n");
  fprintf(beamerFile,"\\begin{frame} \n");
  fprintf(beamerFile,"\\frametitle{Second Slide} \n");
  fprintf(beamerFile,"Contents of the second slide \n");
  fprintf(beamerFile,"\\end{frame} \n");
  fprintf(beamerFile,"\\end{document}");

  fclose(beamerFile);
	system("pdflatex beamerFile.tex");
	system("evince beamerFile.pdf");
}
