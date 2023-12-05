#pragma once

#include <stdlib.h>
#include <stdbool.h>

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

typedef struct {
    FunctionType function;
    int filters_size;
    struct {
        char column[MAX_STRING_SIZE];
        LogicalOperation operation;
        Element *value;
    } filters[];
} Query;

Element *create_boolean(bool value);

Element *create_number(int32_t value);

Element *create_double(double value);

Element *create_string(char *value);

void print_element(Element *el);
