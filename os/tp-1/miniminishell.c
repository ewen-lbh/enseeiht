#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h> /* wait */

int main(int argc, char *argv[])
{
    int codeTerm;
    char buf[30]; /* kbd input */
    int ret;      /* scanf exit code */
    while (true)
    {
        printf(">>>mmsh: ");
        ret = scanf("%s", buf);

        if (ret == EOF)
        {
            break;
        }

        char *path = (char *)malloc(100 * sizeof(char));
        char *name = (char *)malloc(100 * sizeof(char));
        sprintf(path, "/bin/%s", buf);
        sprintf(name, "%s", buf);

        if (strcmp(name, "exit") == 0)
        {
            break;
        }

        int child_pid = fork();
        if (child_pid == -1)
        {
            printf("ECHEC: could not fork\n");
        }
        else if (child_pid == 0)
        {
            if (execlp(path, name, NULL) != 0)
            {
                exit(EXIT_FAILURE);
            }
        }
        wait(&codeTerm);
        if (!WIFEXITED(codeTerm))
        {
            printf("ECHEC: child did not exit (was killed by a signal)\n");
        }
        if (WEXITSTATUS(codeTerm) == EXIT_SUCCESS)
        {
            printf("SUCCES\n");
        }
        else
        {
            printf("ECHEC\n");
        }
    }
    printf("\nSalut\n");
    return EXIT_SUCCESS; /* -> exit(EXIT_SUCCESS); pour le père */
}
