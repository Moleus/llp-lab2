#include "types.h"

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
