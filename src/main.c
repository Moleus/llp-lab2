#include "y.tab.h"


int main() {
    int status = yyparse();
    print_query(q);
    return status;
}
