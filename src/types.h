#ifndef PARSER_TYPES_H
#define PARSER_TYPES_H

#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include "string.h"

#define MAX_STRING_SIZE 50
#define MAX_PATH_DEPTH 10

typedef enum {
    NOP = 0,
    UPDATE_OP = 1,
    CREATE_OP,
    DELETE_OP,
    SELECT_ALL_OP
} FunctionType;

typedef enum {
    NO_OP = 0,
    EQUALS_OP = 1,
    NOT_EQUALS_OP,
    LESS_THAN_OP,
    GREATER_THAN_OP,
} LogicalOperation;

typedef enum {
    TODO
} FilterOperation;

typedef enum {
    BOOLEAN_TYPE = 1,
    NUMBER_TYPE,
    DOUBLE_TYPE,
    STRING_TYPE
} ValueType;

typedef struct {
    ValueType type;
    union {
        bool boolean;
        int32_t number;
        double double_number;
        char string[MAX_STRING_SIZE];
    };
} Element;

typedef struct {
    char name[MAX_STRING_SIZE];
} FilterTarget;

typedef struct {
    LogicalOperation operation;
    FilterTarget left;
    Element *right;
    bool is_single_value;
} FilterExpr;

typedef struct {
    ValueType type;
    char name[MAX_STRING_SIZE];
} Property;

typedef struct Filter {
    union {
        Property* property; // when adding new property
        FilterExpr* filter; // when querying
    };
    struct Filter *next;
} Filter;

typedef enum {
    SINGLE_ATTRIBUTE = 1,
    ASTERISK_PATH,
} PathType;

typedef struct {
    char node[MAX_STRING_SIZE];
    PathType type;
} Path;

typedef struct {
    FilterExpr *filter;
    FunctionType func;
    Path path[MAX_PATH_DEPTH];
    int path_len;
} Query;

Element *create_boolean(bool value);

Element *create_number(int32_t value);

Element *create_double(double value);

Element *create_string(char *value);

Filter *create_filter(char *attribute, int operator, Element *value);

Filter *create_filter_single_value(Element *value);

void print_element(Element *el);

void print_query(Query query);

void add_node_to_path(Query *query, char *node);
#endif //PARSER_TYPES_H