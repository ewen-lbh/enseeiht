#include <stdio.h>    /* entrées/sorties */
#include <unistd.h>   /* primitives de base : fork, ...*/
#include <stdlib.h>   /* exit */
#include <signal.h>

#define MAX_PAUSES 10     /* nombre d'attentes maximum */

void pouet(int sig) {
    printf("🤡POUET🤡 received %d in %d\n", sig, getpid());
}

int main(int argc, char *argv[]) {
	int nbPauses;

    for (int i = 1; i <= SIGRTMAX; i++)
        signal(i, pouet);

    int fork_res = fork();
    if (fork_res == -1)
        printf("bruh\n");
    
    if (fork_res == 0) {
        for (int i = 0; i < 100; i++)
        {
            sleep(1);
        }
        
    } else {
	
	nbPauses = 0;
	printf("Processus de pid %d\n", getpid());
	for (nbPauses = 0 ; nbPauses < MAX_PAUSES ; nbPauses++) {
		pause();		// Attente d'un signal
		printf("pid = %d - NbPauses = %d\n", getpid(), nbPauses);
    } ;
    }
    return EXIT_SUCCESS;
}
