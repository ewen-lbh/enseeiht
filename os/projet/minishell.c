#define _POSIX_SOURCE
#include "readcmd.h"
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <signal.h>
#include <errno.h>

#define UNWRAP(expression)   \
	if ((expression) < 0)    \
	{                        \
		perror(#expression); \
		exit(EXIT_FAILURE);  \
	}

#define TRACE(...)                        t ad\
	if (strcmp(getenv("DEBUG"), "") != 0) \
	{                                     \
		printf("[trace] ");               \
		printf(__VA_ARGS__);              \
	}

struct job
{
	int pid;
	char *command;
	bool running;
};

static struct job jobs[999];

// PID du processus en foreground (0 si le shell est en premier plan)
static int current_pid = 0;

int last_job_index()
{
	TRACE("get last job index\n");
	int i = -1;
	while (jobs[i].command != NULL)
	{
		i++;
	}
	return i;
}

void delete_job(int index)
{
	TRACE("delete job %d\n", index);
	free(jobs[index].command);
	for (int i = index; i < last_job_index(); i++)
	{
		jobs[i] = jobs[i + 1];
	}
}

int job_index_by_pid(int pid)
{
	TRACE("get job index by pid %d\n", pid);
	for (int index = 0; index <= 999; index++)
	{
		printf("@%d #%d\n", jobs[index].pid, index);
		if (jobs[index].pid == pid)
		{
			return index;
		}
	}
	TRACE("job not found by pid %d\n", pid);
	exit(EXIT_FAILURE);
}

int get_job_index(char *arg)
{
	TRACE("get job index from %s\n", arg);
	int last_job = last_job_index();
	int job_index;
	if (arg == NULL)
	{
		job_index = last_job;
	}
	else
	{
		job_index = atoi(arg) - 1;
	}
	if (job_index > last_job + 1 || job_index < 0)
	{
		printf("le job %d n'existe pas (jobs dans [%d, %d])\n", job_index + 1, 1, last_job + 1);
		exit(EXIT_FAILURE);
	}
	return job_index;
}

void switch_foreground_process(int pid)
{
	TRACE("switch foreground process to %d\n", pid);
	struct sigaction foreground_handler;
	sigemptyset(&foreground_handler.sa_mask);
	foreground_handler.sa_flags = 0;

	current_pid = pid;
	tcsetpgrp(STDOUT_FILENO, current_pid);
	do
	{
		pause();
	} while (current_pid > 0);
	tcsetpgrp(STDOUT_FILENO, getpgrp());

	foreground_handler.sa_handler = SIG_IGN;
	sigaction(SIGINT, &foreground_handler, NULL);
	sigaction(SIGTSTP, &foreground_handler, NULL);
}

int start_child(int *gpid, int in, int out, char **first_call)
{
	TRACE("start child with gpid=%d, in=%d, out=%d, first_call[0]=%s\n", *gpid, in, out, first_call[0]);
	pid_t pid;
	struct sigaction child_handler;
	sigemptyset(&child_handler.sa_mask);
	child_handler.sa_flags = 0;
	int pipe_fd[2];

	if (out < 0)
	{
		UNWRAP(pipe(pipe_fd));
	}

	UNWRAP(pid = fork());

	if (pid == 0)
	{
		if (out < 0)
		{
			UNWRAP(close(pipe_fd[0]));
			out = pipe_fd[1];
		}

		UNWRAP(setpgid(getpid(), *gpid));

		child_handler.sa_handler = SIG_DFL;
		sigaction(SIGINT, &child_handler, NULL);
		sigaction(SIGTSTP, &child_handler, NULL);
		sigaction(SIGTTOU, &child_handler, NULL);
		sigaction(SIGTTIN, &child_handler, NULL);

		UNWRAP(dup2(in, STDIN_FILENO));
		UNWRAP(dup2(out, STDOUT_FILENO));

		UNWRAP(execvp(first_call[0], first_call));
		exit(EXIT_FAILURE);
	}

	if (*gpid == 0)
	{
		*gpid = pid;
	}

	if (in != STDIN_FILENO)
	{
		UNWRAP(close(in));
	}

	if (out < 0)
	{
		UNWRAP(close(pipe_fd[1]));
		return pipe_fd[0];
	}
	else if (out != STDOUT_FILENO)
	{
		UNWRAP(close(out));
	}

	return STDOUT_FILENO;
}

void child_handler_action()
{
	TRACE("child handler action\n");
	int pid;
	int status;

	do
	{
		pid = waitpid(-1, &status, WNOHANG | WUNTRACED);
		if (WIFSTOPPED(status))
		{
			jobs[job_index_by_pid(pid)].running = false;
		}
		else
		{
			printf("💀 %d (pid %d)\n", WEXITSTATUS(status), pid);
		}
	} while (pid > 0);

	if (pid < 0 && errno != ECHILD)
	{
		perror("waitpid");
		exit(EXIT_FAILURE);
	}
}

static bool got_signal = false;

struct cmdline *prompt()
{
	struct cmdline *commandline;
	do
	{
		do
		{
			printf("🐚 ");
			fflush(stdin);
			got_signal = false;
			commandline = readcmd();

		} while (got_signal);
		if (commandline == NULL)
		{
			printf("\n");
			return NULL;
		}
		if (commandline->err)
		{
			printf("🚨 %s\n", commandline->err);
			return NULL;
		}
	} while (*(commandline->seq) == NULL);
	return commandline;
}

int main()
{

	struct sigaction main_handler;
	sigemptyset(&main_handler.sa_mask);
	main_handler.sa_flags = 0;

	main_handler.sa_handler = child_handler_action;
	sigaction(SIGCHLD, &main_handler, NULL);

	main_handler.sa_handler = SIG_IGN;
	sigaction(SIGINT, &main_handler, NULL);
	sigaction(SIGTSTP, &main_handler, NULL);

	// pour par ex. ViM
	sigaction(SIGTTOU, &main_handler, NULL);
	sigaction(SIGTTIN, &main_handler, NULL);

	struct cmdline *commandline;

	while (commandline = prompt())
	{

		char ***pipeline = commandline->seq;
		char **first_call = commandline->seq[0];

		if (strcmp(first_call[0], "exit") == 0)
		{
			break;
		}

		if (strcmp(first_call[0], "cd") == 0)
		{
			chdir(first_call[1]);
			continue;
		}

		if (strcmp(first_call[0], "lj") == 0)
		{
			for (int i = 0; i <= last_job_index() + 1; i++)
			{
				if (jobs[i].running)
				{
					printf("🏃 ");
				}
				else
				{
					printf("🛏️ ");
				}
				printf("%d (%d) %s\n", i + 1, jobs[i].pid, jobs[i].command);
			}
			continue;
		}

		if (strcmp(first_call[0], "sj") == 0)
		{
			int job_index = get_job_index(first_call[1]);
			kill(-jobs[job_index].pid, SIGSTOP);
			jobs[job_index].running = false;
			continue;
		}

		if (strcmp(first_call[0], "bg") == 0 || strcmp(first_call[0], "fg") == 0)
		{
			int job_index = get_job_index(first_call[1]);
			kill(-jobs[job_index].pid, SIGCONT);
			jobs[job_index].running = true;

			if (strcmp(first_call[0], "fg") == 0)
			{
				switch_foreground_process(jobs[job_index].pid);
			}

			continue;
		}

		int pipeline_in = STDIN_FILENO;
		int pipeline_out = STDOUT_FILENO;
		pid_t gpid = 0;

		if (commandline->in)
		{
			int fd_in;
			UNWRAP(fd_in = open(commandline->in, O_RDONLY));
			pipeline_in = fd_in;
		}

		if (commandline->out)
		{
			int fd_out;
			UNWRAP(fd_out = open(commandline->out, O_WRONLY | O_CREAT | O_TRUNC, 0644));
			pipeline_out = fd_out;
		}

		while (*pipeline)
		{
			pipeline_in = start_child(&gpid, pipeline_in, pipeline[1] ? -1 : pipeline_out, *pipeline);
			pipeline++;
		}

		int newJobIndex = last_job_index() + 1;
		jobs[newJobIndex].pid = gpid;
		jobs[newJobIndex].running = false;
		printf("%s\n", first_call[0]);
		jobs[newJobIndex].command = malloc(sizeof(char) * (strlen(first_call[0]) + 1));
		strcpy(jobs[newJobIndex].command, first_call[0]);
		printf("%s\n", jobs[newJobIndex].command);

		if (commandline->backgrounded == NULL)
		{
			switch_foreground_process(gpid);
		}
	}

	for (int i = 0; i < last_job_index(); i++)
	{
		kill(-jobs[i].pid, SIGKILL);
	}

	return EXIT_SUCCESS; /* -> exit(EXIT_SUCCESS); pour le père */
}
