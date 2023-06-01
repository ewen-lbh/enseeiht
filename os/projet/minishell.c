#define _POSIX_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <string.h>
#include <signal.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <stdarg.h>
#include "readcmd.h"

#define UNWRAP(expression)   \
	if ((expression) < 0)    \
	{                        \
		perror(#expression); \
		exit(EXIT_FAILURE);  \
	}

enum style_tag
{
	RESET,
	BOLD,
	DIM,
	ITALIC,
	UNDERLINED,
	SLOW_BLINK,
	FAST_BLINK,
	INVERTED,
	HIDDEN,
	CROSSED_OUT,
};

enum color_tag
{
	BLACK,
	RED,
	GREEN,
	YELLOW,
	BLUE,
	MAGENTA,
	CYAN,
	WHITE,
};

static bool tracing = false;

void TRACE(const char *format, ...)
{
	if (tracing)
	{
		printf("\033[0m\033[2m[trace] ");
		va_list args;
		va_start(args, format);
		vprintf(format, args);
		va_end(args);
		printf("\033[0m\n");
	}
}

struct job
{
	pid_t pid;
	bool running;
	char *command;
};

static struct job jobs[999];

void style(enum style_tag style_tag, enum color_tag color_tag)
{
	// TRACE("set style style=%d color=%d", style_tag, color_tag);
	printf("\033[3%dm", color_tag);
	printf("\033[%dm", style_tag);
}

bool streq(char *a, char *b)
{
	return strcmp(a, b) == 0;
}

int last_job_index()
{
	TRACE("get last job index");
	int i = 0;
	while (jobs[i].command != NULL)
	{
		i++;
	}
	TRACE("last job index is %d", i - 1);
	return i - 1;
}

int job_index_by_pid(int pid)
{
	TRACE("get job index by pid %d", pid);
	int i = 0;
	while (jobs[i].command != NULL)
	{
		if (jobs[i].pid == pid)
		{
			TRACE("job index is %d", i);
			return i;
		}
		i++;
	}
	TRACE("job index not found");
	return -1;
}

void add_job(int pid, char ***commandline)
{
	int newJobIndex = last_job_index() + 1;
	jobs[newJobIndex].pid = pid;
	jobs[newJobIndex].running = false;
	jobs[newJobIndex].command = malloc(sizeof(char) * (strlen(commandline[0][0]) + 1));
	strcpy(jobs[newJobIndex].command, commandline[0][0]);
	TRACE("added jobs[%d] (%d) %s", newJobIndex, pid, jobs[newJobIndex].command);
}

int remove_job(int pid)
{
	TRACE("remove job %d", pid);
	int i = job_index_by_pid(pid);
	if (i == -1)
	{
		TRACE("job %d not found", pid);
		return 0;
	}

	free(jobs[i].command);
	jobs[i].command = NULL;
	for (int j = i + 1; j <= last_job_index(); j++)
	{
		jobs[j - 1] = jobs[j];
	}
	return 0;
}

static bool got_signal;

struct cmdline *prompt()
{
	struct cmdline *commandline;
	do
	{
		do
		{
			char working_directory[9999];
			getcwd(working_directory, 9999);
			style(ITALIC, MAGENTA);
			printf("\n\n%s", working_directory);
			style(RESET, BLACK);
			printf("\n🐚 ");
			style(BOLD, CYAN);
			fflush(stdin);

			got_signal = false;
			commandline = readcmd();
			style(RESET, BLACK);
		} while (got_signal);

		if (commandline == NULL)
		{
			return NULL;
		}

		if (commandline->err)
		{
			printf("error: %s\n", commandline->err);
			return NULL;
		}
	} while (*(commandline->seq) == NULL);

	if (streq(**(commandline->seq), "exit"))
	{
		return NULL;
	}

	return commandline;
}

static int current_pid = 0;

void send_signal_to_current_process(int signal)
{
	if (signal == SIGTSTP)
	{
		kill(-current_pid, SIGTSTP);
	}
	else if (signal == SIGINT)
	{
		kill(-current_pid, SIGTERM);
	}
	else
	{
		kill(-current_pid, signal);
	}

	got_signal = true;
}

void child_handler_action()
{
	int pid;
	int status;
	got_signal = true;

	while ((pid = waitpid(-1, &status, WNOHANG | WUNTRACED)) > 0)
	{
		if (WIFSTOPPED(status))
		{
			jobs[job_index_by_pid(pid)].running = false;
			TRACE("job %d stopped", pid);
		}
		else
		{
			UNWRAP(remove_job(pid));
			TRACE("job pid=%d removed", pid);
			if (WEXITSTATUS(status))
		}

		if (pid == current_pid)
		{
			current_pid = 0;
		}
	}

	if (pid < 0 && errno != ECHILD)
	{
		perror("waitpid");
		exit(EXIT_FAILURE);
	}
}

void switch_current_process(int pid)
{
	struct sigaction child_handler;
	sigemptyset(&child_handler.sa_mask);
	child_handler.sa_flags = 0;

	current_pid = pid;

	tcsetpgrp(STDERR_FILENO, pid);

	do
	{
		pause();
	} while (current_pid > 0);

	tcsetpgrp(STDERR_FILENO, getpgrp());

	child_handler.sa_handler = SIG_DFL;
	sigaction(SIGTSTP, &child_handler, NULL);
	sigaction(SIGINT, &child_handler, NULL);
}

int start_child(int *group_pid, int child_stdin, int child_stdout, char **args)
{
	int pid;
	struct sigaction child_handler;
	sigemptyset(&child_handler.sa_mask);
	child_handler.sa_flags = 0;

	int pipe_to_next_child[2];
	bool outputs_to_pipe = child_stdout < 0;
	if (outputs_to_pipe)
	{
		style(RESET, BLACK);
		UNWRAP(pipe(pipe_to_next_child));
		child_stdout = pipe_to_next_child[1];
	}

	UNWRAP(pid = fork());

	if (pid == 0)
	{
		if (outputs_to_pipe)
		{
			UNWRAP(close(pipe_to_next_child[0]));
			child_stdout = pipe_to_next_child[1];
		}

		UNWRAP(setpgid(getpid(), *group_pid));

		child_handler.sa_handler = SIG_DFL;
		sigaction(SIGTSTP, &child_handler, NULL);
		sigaction(SIGINT, &child_handler, NULL);
		sigaction(SIGTTOU, &child_handler, NULL);
		sigaction(SIGTTIN, &child_handler, NULL);

		UNWRAP(dup2(child_stdin, STDIN_FILENO));
		UNWRAP(dup2(child_stdout, STDOUT_FILENO));

		execvp(args[0], args);
		perror("execvp");
		exit(EXIT_FAILURE);
	}

	if (*group_pid == 0)
	{
		*group_pid = pid;
	}

	if (child_stdin != STDIN_FILENO)
	{
		UNWRAP(close(child_stdin));
	}

	if (outputs_to_pipe)
	{
		UNWRAP(close(pipe_to_next_child[1]));
		return pipe_to_next_child[0];
	}
	else if (child_stdout != STDOUT_FILENO)
	{
		UNWRAP(close(child_stdout));
	}

	return STDIN_FILENO;
}

// returns the last job index if NULL is given
int get_job_index_from_arg(char *arg)
{
	if (arg == NULL)
	{
		return last_job_index();
	}

	return atoi(arg);
}

char *expand_home_prefix(char *path)
{
	if (path[0] == '~')
	{
		char *home = getenv("HOME");
		char *new_path = malloc(strlen(home) + strlen(path) + 1);
		strcpy(new_path, home);
		strcat(new_path, path + 1);
		return new_path;
	}

	return path;
}

int main()
{
	struct sigaction signals_handler;
	sigemptyset(&signals_handler.sa_mask);
	signals_handler.sa_flags = 0;

	signals_handler.sa_handler = child_handler_action;
	sigaction(SIGCHLD, &signals_handler, NULL);

	signals_handler.sa_handler = SIG_IGN;
	sigaction(SIGTSTP, &signals_handler, NULL);
	sigaction(SIGINT, &signals_handler, NULL);
	sigaction(SIGTTOU, &signals_handler, NULL);
	sigaction(SIGTTIN, &signals_handler, NULL);

	struct cmdline *commandline;

	while ((commandline = prompt()))
	{
		style(RESET, BLACK);
		for (int _ = 0; _ < 50; _++)
		{
			printf("─");
		}

		printf("\n");
		char **first_command_args = *(commandline->seq);
		char *first_command = first_command_args[0];

		if (streq(first_command, "cd"))
		{
			if (chdir(expand_home_prefix(first_command_args[1])) < 0)
			{
				perror("chdir");
			}
			continue;
		}
		if (streq(first_command, "lj"))
		{
			TRACE("listing jobs");
			for (int i = 0; i <= last_job_index(); i++)
			{
				printf("%s %d (%d) %s\n", jobs[i].running ? "🏃" : "🛑", i + 1, jobs[i].pid, jobs[i].command);
			}
			continue;
		}

		if (streq(first_command, "sj"))
		{
			int job_index = get_job_index_from_arg(first_command_args[1]);
			kill(-jobs[job_index].pid, SIGSTOP);
			continue;
		}

		if (streq(first_command, "susp"))
		{
			kill(getpid(), SIGSTOP);
		}

		if (streq(first_command, "trace"))
		{
			tracing = !tracing;
			style(ITALIC, YELLOW);
			printf("trace is %s.\n", tracing ? "on" : "off");
			style(RESET, RESET);
			continue;
		}

		if (streq(first_command, "fg") || streq(first_command, "bg"))
		{
			int job_index = get_job_index_from_arg(first_command_args[1]);
			int pid = jobs[job_index].pid;

			kill(-pid, SIGCONT);

			if (streq(first_command, "fg"))
			{
				jobs[job_index].running = true;
				switch_current_process(pid);
			}

			continue;
		}

		int current_child_stdin = STDIN_FILENO;
		int pipeline_stdout = STDOUT_FILENO;
		int group_pid = 0;

		if (commandline->in)
		{
			current_child_stdin = open(commandline->in, O_RDONLY);
			if (current_child_stdin < 0)
			{
				perror("open stdin redirector");
				continue;
			}
		}

		if (commandline->out)
		{
			pipeline_stdout = open(commandline->out, O_WRONLY | O_CREAT | O_TRUNC, 0644);
			if (pipeline_stdout < 0)
			{
				perror("open stdout redirector");
				continue;
			}
		}

		char ***commands_left = commandline->seq;
		while (*commands_left)
		{
			bool is_last_command = *(commands_left + 1) == NULL;
			current_child_stdin = start_child(&group_pid, current_child_stdin, is_last_command ? pipeline_stdout : -1, *commands_left);
			commands_left++; // XXX c'est vraiment dégueulasse d'itérer comme ça.
		}

		add_job(group_pid, commandline->seq);

		if (!commandline->backgrounded)
		{
			switch_current_process(group_pid);
		}
	}

	// kill everyone
	for (int i = 0; i <= last_job_index(); i++)
	{
		kill(-jobs[i].pid, SIGKILL);
	}

	return EXIT_SUCCESS;
}
