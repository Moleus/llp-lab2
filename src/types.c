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

Filter *create_filter(char *attribute, int operator, Element *value) {
    FilterExpr *filter_expr = my_malloc(sizeof(FilterExpr));
    Filter *filter = my_malloc(sizeof(Filter));
    strcpy(filter_expr->left.name, attribute);
    switch (operator) {
        case 0:
            filter_expr->operation = EQUALS_OP;
            break;
        case 1:
            filter_expr->operation = NOT_EQUALS_OP;
            break;
        case 2:
            filter_expr->operation = LESS_THAN_OP;
            break;
        case 3:
            filter_expr->operation = GREATER_THAN_OP;
            break;
    }
    filter_expr->right = value;
    filter->filter = filter_expr;
    filter->next = NULL;
    return filter;
}

void add_node_to_path(Query *query, char *node) {
    Path *path = my_malloc(sizeof(Path));
    strcpy(path->node, node);
    path->type = SINGLE_ATTRIBUTE;
    query->path[query->path_len++] = *path;
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

void print_path(Path paths[MAX_PATH_DEPTH], int path_len) {
    for (int i = 0; i < path_len; i++) {
        printf("%s", paths[i].node);
        if (paths[i].type == ASTERISK_PATH) {
            printf(".*");
        }
        if (i != path_len - 1) {
            printf("/");
        }
    }
    printf("\n");
}

void print_query(Query query) {
    printf("Query contents: ");
    print_path(query.path, query.path_len);
}
