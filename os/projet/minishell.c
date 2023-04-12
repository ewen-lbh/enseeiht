#include "readcmd.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h> /* wait */

struct job
{
    int pid;
    char *command;
};

int main(int argc, char *argv[])
{
    int codeTerm;
    struct job jobs[999];
    int lastJob = -1;

    while (true)
    {
        printf("🐚 ");
        struct cmdline *commandline;
        commandline = readcmd();

        if (commandline == NULL)
        {
            break;
        }

        // pour l'instant on ne traite pas les pipelines, donc on prend que le premier élément de ***seq
        char **args = commandline->seq[0];

        if (strcmp(args[0], "exit") == 0)
        {
            break;
        }

        if (strcmp(args[0], "cd") == 0)
        {
            chdir(args[1]);
            continue;
        }

        if (strcmp(args[0], "lj") == 0)
        {
            for (int i = 0; i < lastJob; i++)
            {
                printf("  %d (%d) %s\n", i + 1, jobs[i].pid, jobs[i].command);
            }
            continue;
        }

        int child_pid = fork();
        if (child_pid == -1)
        {
            printf("ECHEC: could not fork\n");
        }
        else if (child_pid == 0)
        {
            if (execvp(args[0], args) != 0)
            {
                exit(EXIT_FAILURE);
            }
        }
        else
        {
            if (commandline->backgrounded)
            {
                struct job newJob = {child_pid, args[0]};
                jobs[lastJob++] = newJob;
                printf("💤️ %d (%d)\n", lastJob + 1, child_pid);
            }
            else
            {
                waitpid(child_pid, &codeTerm, 0);
                if (!WIFEXITED(codeTerm))
                {
                    printf("ECHEC: child did not exit (was killed by a signal)\n");
                }
                if (WEXITSTATUS(codeTerm) != EXIT_SUCCESS)
                {
                    printf("💀 %d\n", WEXITSTATUS(codeTerm));
                }
            }
        }
    }
    return EXIT_SUCCESS; /* -> exit(EXIT_SUCCESS); pour le père */
}
