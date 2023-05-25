#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <fcntl.h>

int main(char *argc, char **argv)
{
    // Run who | grep nom_utilisateur | wc -l

    int pipe_descrs[2];
    if (pipe(pipe_descrs))
    {
        perror("pipe");
        return EXIT_FAILURE;
    }

    int child_pid = fork();
    if (child_pid == 0)
    {
        dup2(pipe_descrs[1], STDOUT_FILENO);
        execlp("who", "who", NULL);
    }
    else
    {

        printf("ran who\n");
        int buf[32];
        read(pipe_descrs[0], buf, 32);
        printf("%s\n", buf);

        wait(&child_pid);

        child_pid = fork();
        if (child_pid == 0)
        {
            dup2(pipe_descrs[0], STDIN_FILENO);
            dup2(pipe_descrs[1], STDOUT_FILENO);
            execlp("grep", "grep", argv[1], NULL);
        }
        else
        {

            printf("ran grep\n");
            int buf2[32];
            read(pipe_descrs[0], buf2, 32);
            printf("%s\n", buf2);

            wait(&child_pid);

            child_pid = fork();
            if (child_pid == 0)
            {
                dup2(pipe_descrs[0], STDIN_FILENO);
                execlp("wc", "wc", "-l", NULL);
            }
            else
            {
                wait(&child_pid);

                close(pipe_descrs[0]);
                close(pipe_descrs[1]);

                printf("done\n");
            }
        }
    }
}
