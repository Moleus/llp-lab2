%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
#include "types.h"
%}

%%
"(" { return LPAREN; }
")" { return RPAREN; }
"[" { return LBRACKET; }
"]" { return RBRACKET; }
"|" { return PIPE; }
"//" { return SLASHSLASH; }
"/" { return SLASH; }
"@" { return AT; }
"=" { return EQUALS_OP; }
"!=" { return NOT_EQUALS_OP; }
"<" { return LESS_THAN_OP; }
">" { return GREATER_THAN_OP; }

\n { return EOL; }

[a-zA-Z_]* { yylval.string = strdup(yytext); return WORD_T; }

. { printf("Unrecognized character: %s\n", yytext); exit(1); }

%%

int yywrap(void){
	return 1;
}