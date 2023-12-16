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
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h>
    #include <stdio.h>
    #include "types.h"
    extern Query q;
	int yylex();
	void yyerror(const char *s);
}

%union{
    int bool_value;
    int int_value;
    double double_value;
    char *string;

    FunctionType func_type;
    FilterOperation filter_op;
    Filter *filter;
    Element *el;
}

%{
Query q = {};
int tab_level = 0;

void print_tab(long tab_level) {
    for (int i = 0; i < tab_level; i++) {
        printf("\t");
    }
}
%}


/* symbols */
%token LPAREN RPAREN LBRACKET RBRACKET PIPE SLASHSLASH SLASH AT

/* functions */
%token <string> UPDATE DELETE CREATE ASTERISK
%token EOL

%token <int_value> INT_T
%token <bool_value> BOOL_T
%token <string> WORD_T
%token <double_value> DOUBLE_T

/* filter tokens */
%token <int_value> EQUALS_T NOT_EQUALS_T LESS_THAN_T GREATER_THAN_T

%type <string> function_call
%type <string> function_name
%type <string> attribute
%type <filter> filter_expr
%type <filter> filters
%type <filter> filter
%type <string> node
%type <int_value> compare_op
%type <el> node_value

%%

query
    : %empty  /* empty */
    | query node
    | query node EOL
    | query node filters EOL
    | function_call EOL
    ;

node
    : SLASH WORD_T {
        tab_level++;
        print_tab(tab_level);
        add_node_to_path(&q, $2);
        printf("word after slash: %s\n", $2);
        $$ = $2;
    }
    | WORD_T {
        print_tab(tab_level);
        add_node_to_path(&q, $1);
        printf("node: %s\n", $1);
        $$ = $1;
    }
    ;

function_call
    : function_name LPAREN query RPAREN {
        printf("function call: %s\n", $1);
    }
    ;

function_name : CREATE | UPDATE | DELETE

filters
    : filter
    | filters filter {
        printf("filters: %s\n", $2);
        $$ = $2;
        $2->next = $1;
    }
    ;

filter
    : LBRACKET filter_expr RBRACKET {
        $$ = $2;
    }
    ;

filter_expr
    : attribute compare_op node_value {
        $$ = create_filter($1, $2, $3);
    }
    ;

node_value
    : BOOL_T { $$ = create_boolean($1);  }
    | INT_T { $$ = create_number($1); }
    | DOUBLE_T { $$ = create_double($1); }
    | WORD_T { $$ = create_string($1); }

attribute
    : AT WORD_T { $$ = $2; }
    ;

compare_op: EQUALS_T | NOT_EQUALS_T | LESS_THAN_T | GREATER_THAN_T;

%%

void yyerror(const char *s) {
    fprintf(stderr, "error: %s\n", s);
}

