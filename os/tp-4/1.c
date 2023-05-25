#include <stdio.h>
#include <unistd.h>

int main(char* argc, char** argv) {
    execlp("ls", "ls", "-h1t", NULL);
    return 0;
}
