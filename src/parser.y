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
    LogicalOperation logical_op;
    FilterOperation filter_op;
    FilterExpr *filter_expr;
    Element *el;
}

%{
Query q = {};
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
%token <logical_op> EQUALS_T NOT_EQUALS_T LESS_THAN_T GREATER_THAN_T

%type <string> function_name
%type <string> attribute
// TODO: Добавить типы для атрибутов
%type <filter_expr> filter_expr
%type <string> filter
%type <string> node
%type <logical_op> compare_op

%type <el> node_value

%%

query
    : %empty  /* empty */
    | query node filter EOL
    | query node EOL
    | function_call EOL
    ;

// constructs a Path in q.
node
    : SLASH WORD_T {
        add_node_to_path(&q, $2);
    }
    | SLASH SLASH ASTERISK {
        q.path[q.path_len].type = ASTERISK_PATH;
    }
    ;

node_value
    : BOOL_T { $$ = create_boolean($1);  }
    | INT_T { $$ = create_number($1); }
    | DOUBLE_T { $$ = create_double($1); }
    | WORD_T { $$ = create_string($1); }

function_call
    : function_name LPAREN query RPAREN
    ;

function_name : CREATE | UPDATE | DELETE

filter
    : LBRACKET filter_expr RBRACKET {
        q.filter = $2;
    }
    ;

filter_expr
    : attribute compare_op node_value {
        $$ = create_filter($1, $2, $3);
    }
    ;

attribute
    : AT WORD_T { $$ = $2; }
    ;

compare_op: EQUALS_T | NOT_EQUALS_T | LESS_THAN_T | GREATER_THAN_T;

%%

void yyerror(const char *s) {
    fprintf(stderr, "error: %s\n", s);
}

