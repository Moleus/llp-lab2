#include "types.h"

void *my_malloc(size_t size) {
    void *ptr = malloc(size);
    printf("Allocated %zu bytes at %p\n", size, ptr);
    return ptr;
}

Element *create_boolean(bool value) {
    Element *el = my_malloc(sizeof(Element));
    el->type = BOOLEAN_TYPE;
    el->boolean = value;
    return el;
}

Element *create_number(int32_t value) {
    Element *el = my_malloc(sizeof(Element));
    el->type = NUMBER_TYPE;
    el->number = value;
    return el;
}

Element *create_double(double value) {
    Element *el = my_malloc(sizeof(Element));
    el->type = DOUBLE_TYPE;
    el->double_number = value;
    return el;
}

Element *create_string(char *value) {
    Element *el = my_malloc(sizeof(Element));
    el->type = STRING_TYPE;
    strcpy(el->string, value);
    return el;
}

FilterExpr *create_filter(char *attribute, LogicalOperation operation, Element *value) {
    FilterExpr *filter = my_malloc(sizeof(FilterExpr));
    strcpy(filter->left.name, attribute);
    filter->operation = operation;
    filter->right = value;
    return filter;
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

void print_query(Query query) {
    printf("Query:\n");
}

void add_node_to_path(Query *query, char *node) {
    Path *path = my_malloc(sizeof(Path));
    strcpy(path->node, node);
    path->type = SINGLE_ATTRIBUTE;
    query->path[query->path_len++] = *path;
}
