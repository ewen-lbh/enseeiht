#include <stdio.h>  /* entrées/sorties */
#include <unistd.h> /* primitives de base : fork, ...*/
#include <stddef.h>
#include <stdlib.h> /* exit */
#include <signal.h>

void pouet(int sig)
{
    printf("Reception %d\n", sig);
}

int main(int argc, char *argv[])
{
    struct sigaction action;
    action.sa_handler = pouet;
    sigemptyset(&action.sa_mask);
    action.sa_flags = 0;
    sigaction(SIGUSR1, &action, NULL);
    sigaction(SIGUSR2, &action, NULL);

    sigset_t new_mask;
    sigemptyset(&new_mask);
    sigaddset(&new_mask, SIGINT);
    sigaddset(&new_mask, SIGUSR1);
    sigprocmask(SIG_BLOCK, &new_mask, NULL);

    sleep(10);

    kill(getpid(), SIGUSR1);
    kill(getpid(), SIGUSR1);

    sleep(5);

    kill(getpid(), SIGUSR2);
    kill(getpid(), SIGUSR2);

    sigdelset(&new_mask, SIGINT);
    sigprocmask(SIG_UNBLOCK, &new_mask, NULL);

    sleep(10);

    sigprocmask(SIG_UNBLOCK, &new_mask, NULL);

    printf("Salut\n");
    return EXIT_SUCCESS;
}
