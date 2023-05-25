#include <stdlib.h>
#include <signal.h>
#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>

static int pipe_descrs[2];
#define N 16

void handler(int sig)
{
    int oufbuf[10];
    read(pipe_descrs[0], oufbuf, 10 * sizeof(int));
    for (int i = 0; i < 10; i++)
    {
        printf("%d\n", oufbuf[i]);
    }
    exit(0);
}

int main(char *argc, char **argv)
{
    int buf[N] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};
    if (pipe(pipe_descrs))
    {
        perror("pipe");
        return EXIT_FAILURE;
    }

    int child_pid = fork();
    if (child_pid == 0)
    {
        signal(SIGINT, &handler);
    }
    else
    {
        signal(SIGINT, SIG_IGN);
        while (true)
        {
            int write_result = write(pipe_descrs[1], buf, N * sizeof(int));
            sleep(1);
            printf("-> %d\n", write_result);
        }
    }
}
