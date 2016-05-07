/* fb2-3 skeleton for include files */
%option noyywrap
%x IFILE
%{
    struct bufstack {
        struct bufstack *prev; /* previous entry */
        YY_BUFFER_STATE bs; /* saved buffer */
        int lineno; /* saved line number */
        char *filename; /* name of this file */
        FILE *f; /* current file */
    } *curbs = 0;
char *curfilename; /* name of current input file */
int newfile(char *fn);
int popfile(void);
%}
%%
match #include statement up through the quote or <
^"#"[ \t]*include[ \t]*\[\"<] { BEGIN IFILE; }