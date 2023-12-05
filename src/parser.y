/*
// Bison parser file for XPath query language
// query examples:
// //book/title | //book/price
// //title[@*]
// /bookstore/book[price>35.00]/title
Язык запросов должен поддерживать возможность описания следующих конструкций:
порождение нового элемента данных, выборка, обновление и удаление существующих
элементов данных по условию
- Условия
    - На равенство и неравенство для чисел, строк и булевских значений
    - На строгие и нестрогие сравнения для чисел
    - Существование подстроки
- Логическую комбинацию произвольного количества условий и булевских значений
- В качестве любого аргумента условий могут выступать литеральные значения (константы) или ссылки на значения, ассоциированные с элементами данных (поля, атрибуты, свойства)
- Разрешение отношений между элементами модели данных любых условий над сопрягаемыми элементами данных
- Поддержка арифметических операций и конкатенации строк не обязательна
*/

%code requires {
	#define YYERROR_VERBOSE 1
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>
    #include <stdio.h>
    #include "types.h"
    extern struct query q;
    extern int yyparse();
	int yylex();
	void yyerror(const char *s);
}

%union{
    int bool_value;
    int int_value;
    double double_value;
    char *string;

    FunctionType func_type;
    LogicalOperation logical_op;
    FilterOperation filter_op;
    Element *el;
}

/* symbols */
%token LPAREN RPAREN LBRACKET RBRACKET PIPE SLASHSLASH SLASH AT COMMA AND OR NOT SEMICOLON

/* filter tokens */
%token EQUALS NOTEQUALS LESSTHAN LESSTHANEQUALS GREATERTHAN GREATERTHANEQUALS

/* functions */
%token <string> UPDATE DELETE CREATE ASTERISK

%token <int_value> INT_T
%token <bool_value> BOOL_T
%token <string> WORD_T
%token <double_value> DOUBLE_T

%type <string> function_name
%type <string> function_arg
%type <string> attribute
// TODO: Добавить типы для атрибутов
%type <string> filter_expr
%type <string> filter
%type <string> node

%type <el> node_value

%%

query
    : /* empty */
    | query node filter
    | query node
    | function_call
    ;

node
    : SLASH WORD_T
    | SLASH SLASH WORD_T
    | SLASH SLASH ASTERISK
    | SLASH AT
    ;

node_value
    : BOOL_T { $$ = create_boolean($1);  }
    | INT_T { $$ = create_number($1); }
    | DOUBLE_T { $$ = create_double($1); }
    | WORD_T { $$ = create_string($1); }

function_call
    : function_name LPAREN function_arg RPAREN
    ;

function_name
    : WORD_T
    ;

function_arg
    : query
    ;

filter
    : LBRACKET filter_expr RBRACKET
    ;

// Логическую комбинацию произвольного количества условий и булевских значений
// В качестве любого аргумента условий могут выступать литеральные значения
// (константы) или ссылки на значения, ассоциированные с элементами данных (поля, атрибуты, свойства)
filter_expr
    : node_value
    | attribute compare_op node_value
    | attribute SEMICOLON val_type

attribute
    : AT WORD_T { $$ = $2; }
    ;

// На равенство и неравенство для чисел, строк и булевских значений
// На строгие и нестрогие сравнения для чисел o
// TODO: Существование подстроки
compare_op: EQUALS | NOTEQUALS | LESSTHAN | LESSTHANEQUALS | GREATERTHAN | GREATERTHANEQUALS;

val_type: INT_T | BOOL_T | DOUBLE_T | WORD_T;
%%

void yyerror(const char *s) {
    fprintf(stderr, "%s\n", s);
}

