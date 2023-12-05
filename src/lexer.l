%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.h"
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
"," { return COMMA; }
"=" { return EQUALS; }
"!=" { return NOTEQUALS; }
"<" { return LESSTHAN; }
"<=" { return LESSTHANEQUALS; }
">" { return GREATERTHAN; }
">=" { return GREATERTHANEQUALS; }
"and" { return AND; }
"or" { return OR; }
"not" { return NOT; }
";" { return SEMICOLON; }

"true"|"false" { yylval.bool_value = !strcmp("true", yytext); return BOOL_T; }

([+-]?[0-9]+) { yylval.int_value = atoi(yytext); return INT_T; }
([+-]?[0-9]+(\.[0-9]+)?)|([+-]?\.[0-9]+) { yylval.double_value = atof(yytext); return DOUBLE_T; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.string = strdup(yytext); return WORD_T; }

"update"       { yylval.func_type = UPDATE_OP; return UPDATE; }
"remove"       { yylval.func_type = DELETE_OP; return DELETE; }
"create"       { yylval.func_type = CREATE_OP; return CREATE; }
"select_all"   { yylval.func_type = SELECT_ALL_OP; return ASTERISK; }

[ \t\n]+ { /* ignore whitespace */ }

. { printf("Unrecognized character: %s\n", yytext); exit(1); }

%%

int yywrap(void){
	return 1;
}