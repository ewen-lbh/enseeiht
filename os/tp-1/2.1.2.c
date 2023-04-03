#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main() {
    fork(); printf("fork 1\n");
    fork(); printf("fork 2\n");
    fork(); printf("fork 3\n");

    return EXIT_SUCCESS;
}
