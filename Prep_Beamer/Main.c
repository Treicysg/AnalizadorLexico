#include <stdio.h>
#include <string.h> /* memset */
#include <stdlib.h>
#include "prep_preprocessor.h"
#include "global.h"


int main( int argc, char *argv[] )
{
  //readFile();
  //clear_token_buffer();
  scanFile();
  //createBeamer();
  checkRegisteredTokens();

}
