#include "parser.h"

static void print_query(Query query) {
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
        printf("      Column: %s\n", query.filters[i].column);
        printf("      Operation: ");
        switch (query.filters[i].operation) {
            case EQUALS_OP:
                printf("EQUALS_OP\n");
                break;
            case NOT_EQUALS_OP:
                printf("NOT_EQUALS_OP\n");
                break;
            case LESS_THAN_OP:
                printf("LESS_THAN_OP\n");
                break;
            case LESS_THAN_OR_EQUALS_OP:
                printf("LESS_THAN_OR_EQUALS_OP\n");
                break;
            case GREATER_THAN_OP:
                printf("GREATER_THAN_OP\n");
                break;
            case GREATER_THAN_OR_EQUALS_OP:
                printf("GREATER_THAN_OR_EQUALS_OP\n");
                break;
            default:
                printf("UNKNOWN\n");
        }
        printf("      Value: ");
        switch (query.filters[i].value->type) {
            case BOOLEAN_TYPE:
                printf("BOOLEAN_TYPE: %s\n", query.filters[i].value->boolean ? "true" : "false");
                break;
            case NUMBER_TYPE:
                printf("NUMBER_TYPE: %d\n", query.filters[i].value->number);
                break;
            case DOUBLE_TYPE:
                printf("DOUBLE_TYPE: %f\n", query.filters[i].value->double_number);
                break;
            case STRING_TYPE:
                printf("STRING_TYPE: %s\n", query.filters[i].value->string);
                break;
            default:
                printf("UNKNOWN\n");
        }
    }
}

int main() {
    int status = yyparse();
    print_query(q);
//    print_allocations_size();
    return status;
}
