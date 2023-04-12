#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

#define BUFSIZE 1024

int main()
{
    char buf[BUFSIZE];
    int sourcefd, destfd;
    int bytesread = 0;

    sourcefd = open("source.txt", O_RDONLY);
    destfd = open("dest.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);

    if (sourcefd == -1)
    {
        perror("open source.txt");
        exit(1);
    }
    if (destfd == -1)
    {
        perror("open dest.txt");
        exit(2);
    }

    while ((bytesread = read(sourcefd, buf, BUFSIZE)) > 0)
    {
        if (write(destfd, buf, bytesread) != bytesread)
        {
            perror("write");
            exit(3);
        }
    }

    if (bytesread == -1)
    {
        perror("read");
        exit(4);
    }

    if (close(sourcefd) == -1)
    {
        perror("close sourcefd");
        exit(5);
    }
    if (close(destfd) == -1)
    {
        perror("close destfd");
        exit(6);
    }
}
