#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <fcntl.h>
#include <unistd.h>

#define BUFSIZE 1024

int main(int argc, char const *argv[])
{
    int child_pid = fork();
    if (child_pid == -1)
    {
        perror("fork");
        return 1;
    }

    if (child_pid == 0)
    {
    }
    else
    {
        int grandchild_pid = fork();
        if (grandchild_pid == -1)
        {
            perror("fork");
            return 1;
        }
        if (grandchild_pid == 0)
        {
            write_numbers();
        }
        else
        {
            read_numbers();
        }
    }
    return 0;
}

int write_numbers()
{
    int fd = open("temp", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    for (int i = 1; i <= 30; i++)
    {
        if (write(fd, &i, 3) == -1)
        {
            perror("write");
            return 2;
        }
        if (i % 10 == 0)
        {
            lseek(fd, 0, SEEK_SET);
        }
        sleep(1);
    }
    return 0;
}

int read_numbers()
{
    while (true)
    {
        int fd = open("temp", O_RDONLY, 0644);
        char buf[BUFSIZE];
        int bytesread = 0;
        for (size_t i = 0; i < 15; i+=3)
        {
            while ((bytesread = read(fd, buf, sizeof(int))) > 0)
            {
                printf("%d\n", buf[i]);
            }
        }
        printf("finished printing for this iteration\n");
        sleep(5);
    }
}
