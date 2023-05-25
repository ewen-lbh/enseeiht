#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>

int main(char *argc, char **argv)
{
    // On récupère les chemins des fichiers
    char *source = argv[1];
    char *destination = argv[2];

    // On crée un fd pour le fichier destination
    int destination_fd = open(destination, O_CREAT | O_WRONLY | O_TRUNC, 0644);
    if (!destination_fd)
    {
        perror("open");
        return EXIT_FAILURE;
    }

    // On remplace stdout par le fd du fichier destination
    // Ceci équivaut au ">" dans un shell
    dup2(destination_fd, STDOUT_FILENO);

    // On cat le fichier source, cat écrira dans /proc/PID/fd/1, qui n'est plus stdout mais le fd du fichier destination
    execlp("cat", "cat", source, NULL);

    // On ferme le fd du fichier destination
    close(destination_fd);
}
