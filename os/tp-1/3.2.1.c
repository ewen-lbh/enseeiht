#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h> /* wait */

int main(int argc, char *argv[]) {
	int idFils, codeTerm;
	execlp("/bin/ls", "ls", "-l", "/home/ewen", NULL);
	idFils=wait(&codeTerm);
	if (idFils == -1) {
		perror("wait ");
		exit(2);
	}
	if (WIFEXITED(codeTerm)) {
		printf("ok: [%d] fin fils %d par exit %d\n",codeTerm,idFils,WEXITSTATUS(codeTerm));
	} else {
		printf("err: [%d] fin fils %d par signal %d\n",codeTerm,idFils,WTERMSIG(codeTerm));
	}
	printf("fin du père\n");
	return EXIT_SUCCESS; /* -> exit(EXIT_SUCCESS); pour le père */
}
