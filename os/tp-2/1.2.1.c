#include <stdio.h>  /* entrées/sorties */
#include <unistd.h> /* primitives de base : fork, ...*/
#include <stddef.h>
#include <stdlib.h> /* exit */
#include <signal.h>

void prout(int sig)
{
    printf("Reception %d\n", sig);
}

int main(int argc, char *argv[])
{
    struct sigaction action;
    action.sa_handler = prout;
    sigemptyset(&action.sa_mask);
    action.sa_flags = 0;
    sigaction(SIGUSR1, &action, NULL);
    sigaction(SIGUSR2, &action, NULL);

    sigset_t new_mask, old_mask;
    sigemptyset(&new_mask);
    sigaddset(&new_mask, SIGINT);
    sigaddset(&new_mask, SIGUSR1);
    sigprocmask(SIG_BLOCK, &new_mask, &old_mask);
    printf("masked SIGINT and SIGUSR1\n");

    // while (1) {
    //     pause();
    // }

    printf("wait 10s\n");

    sleep(10);

    printf("sending 2×SIGUSR1\n");

    kill(getpid(), SIGUSR1);
    kill(getpid(), SIGUSR1);

    printf("wait 5s\n");
    sleep(5);
    printf("sending 2×SIGUSR2\n");

    kill(getpid(), SIGUSR2);
    kill(getpid(), SIGUSR2);

    printf("unmasking SIGUSR1\n");
    sigemptyset(&new_mask);
    sigaddset(&new_mask, SIGINT);
    sigprocmask(SIG_BLOCK, &new_mask, &old_mask);

    printf("wait 10s\n");
    sleep(10);

    /* Restore the old signal mask */
    printf("unmasking SIGINT\n");
    sigprocmask(SIG_SETMASK, &old_mask, NULL);

    printf("Salut\n");
}
