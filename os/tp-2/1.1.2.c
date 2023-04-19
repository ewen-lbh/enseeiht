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

	
	nbPauses = 0;
	printf("Processus de pid %d\n", getpid());
	for (nbPauses = 0 ; nbPauses < MAX_PAUSES ; nbPauses++) {
		pause();		// Attente d'un signal
		printf("pid = %d - NbPauses = %d\n", getpid(), nbPauses);
    } ;
    return EXIT_SUCCESS;
}
