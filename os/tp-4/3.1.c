#include <stdio.h>
#include <unistd.h>

int main(char *argc, char **argv) {
    int child_pid = fork();
    int *pipe_descriptors;

    if (child_pid == 0) {
        int *buf;
        read(pipe_descriptors[0], &buf, 1);
        printf("%d\n", buf);
    } else {
        pipe(&pipe_descriptors);
        write(pipe_descriptors[1], 8, 1);
    }
}
