#ifndef PARSER_TYPES_H
#define PARSER_TYPES_H

#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include "string.h"

#define MAX_STRING_SIZE 50

typedef enum {
    UPDATE_OP,
    CREATE_OP,
    DELETE_OP,
    SELECT_ALL_OP
} FunctionType;

typedef enum {
    EQUALS_OP,
    NOT_EQUALS_OP,
    LESS_THAN_OP,
    LESS_THAN_OR_EQUALS_OP,
    GREATER_THAN_OP,
    GREATER_THAN_OR_EQUALS_OP
} LogicalOperation;

typedef enum {
    TODO
} FilterOperation;

typedef enum {
    BOOLEAN_TYPE,
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

struct query {
    FunctionType function;
    int filters_size;
};

Element *create_boolean(bool value);

Element *create_number(int32_t value);

Element *create_double(double value);

Element *create_string(char *value);

void print_element(Element *el);

void print_query(struct query query);

void *my_malloc(size_t size) {
    void *ptr = malloc(size);
    printf("Allocated %zu bytes at %p\n", size, ptr);
    return ptr;
}

Element *create_boolean(bool value) {
    Element *el = malloc(sizeof(Element));
    el->type = BOOLEAN_TYPE;
    el->boolean = value;
    return el;
}

Element *create_number(int32_t value) {
    Element *el = malloc(sizeof(Element));
    el->type = NUMBER_TYPE;
    el->number = value;
    return el;
}

Element *create_double(double value) {
    Element *el = malloc(sizeof(Element));
    el->type = DOUBLE_TYPE;
    el->double_number = value;
    return el;
}

Element *create_string(char *value) {
    Element *el = malloc(sizeof(Element));
    el->type = STRING_TYPE;
    strcpy(el->string, value);
    return el;
}

void print_element(Element *el) {
    switch (el->type) {
        case BOOLEAN_TYPE:
            printf("%s", el->boolean ? "true" : "false");
            break;
        case NUMBER_TYPE:
            printf("%d", el->number);
            break;
        case DOUBLE_TYPE:
            printf("%f", el->double_number);
            break;
        case STRING_TYPE:
            printf("%s", el->string);
            break;
    }
}

void print_query(struct query query) {
    printf("Query:\n");
    printf("  Function: ");
    switch (query.function) {
        case UPDATE_OP:
            printf("UPDATE_OP\n");
            break;
        case CREATE_OP:
            printf("CREATE_OP\n");
            break;
        case DELETE_OP:
            printf("DELETE_OP\n");
            break;
        case SELECT_ALL_OP:
            printf("SELECT_ALL_OP\n");
            break;
        default:
            printf("UNKNOWN\n");
    }
    printf("  Filters:\n");
    for (int i = 0; i < query.filters_size; ++i) {
        printf("    Filter %d:\n", i);
    }
}


#endif //PARSER_TYPES_H