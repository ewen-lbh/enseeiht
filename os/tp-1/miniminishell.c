#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h> /* wait */

int main(int argc, char *argv[]) {
	int idFils, codeTerm;
	char buf[30]; /* kbd input */
	int ret; /* scanf exit code */
	while (true) {
		printf(">>>mmsh: ");
		ret = scanf("%s", buf);

		if (ret == EOF) {
			break;
		}

		char* path = (char *)malloc(100 * sizeof(char));
		char* name = (char *)malloc(100 * sizeof(char));
		sprintf(path, "/bin/%s", buf);
		sprintf(name, "%s", buf);

		if (strcmp(name, "exit") == 0) {
			break;
		}

		int child_pid = fork();
		if (child_pid == -1) {
			printf("ECHEC: could not fork\n");
		} else if (child_pid == 0) {
			printf("[debug] going into child\n");
			int status = execlp(path, name, NULL);
			if (status != 0) {
				printf("[debug] child exited with %d\n", status);
				printf("ECHEC\n");
			}
			printf("[debug] child finished\n");
			_exit(1);
		} else {
			printf("[debug] going into parent\n");
			wait(&codeTerm);
			if (WIFEXITED(codeTerm)) {
				printf("[debug] child succeeded\n");
				printf("SUCCESS\n");
			} else {
				printf("[debug] child did not exit\n");
				printf("ECHEC\n");
			}
			printf("[debug] child parent finished\n");
		}
	}
	return EXIT_SUCCESS; /* -> exit(EXIT_SUCCESS); pour le père */
}
