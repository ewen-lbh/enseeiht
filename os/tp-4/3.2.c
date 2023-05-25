#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main(char *argc, char **argv)
{
    int child_pid = fork();
    int pipe_descriptors[2];
    int buf[1] = {8};

    int result = pipe(pipe_descriptors);
    if (result == -1)
    {
        perror("pipe");
        return -1;
    }
    write(pipe_descriptors[1], buf, 1);

    if (child_pid == 0)
    {
        int *buf;
        read(pipe_descriptors[0], &buf, 1);
        printf("%d\n", buf);
    }
}
