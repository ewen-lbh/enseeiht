#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main(char *argc, char **argv)
{
    int pipe_descrs[2];
    if (pipe(pipe_descrs))
    {
        perror("pipe");
        return EXIT_FAILURE;
    }

    int child_pid = fork();
    if (child_pid == 0)
    {
        int value;
        do
        {
            // printf("reading %d bytes\n", sizeof(int));
            int result = read(pipe_descrs[0], &value, sizeof(int));
            printf("[%d] %d\n", result, value);
        } while (value > 0);
        printf("sortie de boucle\n");
        exit(0);
    }
    else
    {
        int buf[6] = {1, 2, 3, 4, 5, 8};
        write(pipe_descrs[1], buf, sizeof(int) * 6);
        printf("wrote to PIPEEEDEEEEEEEEEEEES WOOO\n");
        sleep(10);
    }
}
