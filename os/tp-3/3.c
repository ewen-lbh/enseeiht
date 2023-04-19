#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int main()
{
    int tempfd = open("temp.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (tempfd == -1)
    {
        perror("open temp.txt");
        exit(1);
    }

    int child_id = fork();
    if (child_id == -1)
    {
        perror("fork");
        exit(1);
    }

    if (child_id == 0)
    {
        // child writes "ENFANT\n" once per second to temp.txt
        for (int i = 0; i < 10; i++)
        {
            if (write(tempfd, "ENFANT\n", 7) == -1)
            {
                perror("write");
                exit(1);
            }
            sleep(1);
        }
    }
    else
    {
        // parent writes "PARENT\n" ten times, once per second, to temp.txt
        for (int i = 0; i < 10; i++)
        {
            if (write(tempfd, "PARENT\n", 7) == -1)
            {
                perror("write");
                exit(1);
            }
            sleep(1);
        }
    }
}
