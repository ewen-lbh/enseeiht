#define _POSIX_SOURCE  /* pour que kill fonctionne */
#include <stdlib.h>	   /* pour EXIT_SUCCESS */
#include <stdio.h>	   /* pour printf */
#include <stdbool.h>   /* pour bool */
#include <unistd.h>	   /* pour fork */
#include <sys/types.h> /* pour utiliser pid_t… */
#include <sys/wait.h>  /* waitpid */
#include <string.h>	   /* strcmp et ses potes */
#include <signal.h>	   /* gérer les signaux */
#include <errno.h>	   /* variable errno */
#include <fcntl.h>	   /* pour open */
#include <sys/stat.h>  /* pour déclarer S_IRUSR et ses potes */
#include "readcmd.h"   /* parseur de la ligne de commande */

#define TEST_ERR(appel_sys)                                       \
	if ((appel_sys) < 0)                                          \
	{                                                             \
		perror("FATAL_ERROR");                                    \
		fprintf(stderr, "appel qui a échoué : %s\n", #appel_sys); \
		exit(EXIT_FAILURE);                                       \
	}

enum state
{
	ACTIF,
	SUSPENDU,
};

struct job
{
	int id;
	pid_t pid;
	enum state etat;
	char *commande;
};

/** Récupérer l'id maximal
 * @param jobs la liste des taches
 * @param len la longueur de jobs
 * @return id maximal ou -1 si aucune tache
 */
int max_id(struct job *jobs, int len)
{
	int id = -1;

	for (int i = 0; i < len; i++)
	{
		if (jobs[i].id > id)
			id = jobs[i].id;
	}
	return id;
}

/** Copier une commande pour avoir la ligne écrite par l'user
 * @param commande la commande obtenue avec readcmd
 * @return la string qui était écrite par l'user ou NULL si erreur
 */
char *commande_string(char ***commande)
{
	char *commande_texte = NULL;
	char ***pointeur = commande;
	int taille = 0;
	while (*pointeur != NULL)
	{
		char **pointeur_bis = *pointeur;
		while (*pointeur_bis != NULL)
		{
			int new_taille = taille + strlen(*pointeur_bis) + 1; /* le + 1 pour le séparateur */
			if ((commande_texte = realloc(commande_texte, sizeof(char) * new_taille)) == NULL)
				return NULL;
			strcpy(commande_texte + taille, *pointeur_bis);
			taille = new_taille;
			commande_texte[taille - 1] = ' ';
			pointeur_bis++;
		}
		commande_texte[taille - 1] = '|';
		pointeur++;
	}
	commande_texte[taille - 1] = '\0';
	return commande_texte;
}

/** Ajouter une tache active à la liste des taches
 * @param jobs la liste des taches
 * @param len la longueur de jobs
 * @param pid le pid du process de la nouvelle tache
 * @param commande la commande du processus
 * @return la nouvelle taille de jobs (len + 1) ou -1 en cas d'erreur
 */
int add_job(struct job **jobs, int len, int pid, char ***commande)
{
	if ((*jobs = realloc(*jobs, sizeof(struct job) * (len + 1))) == NULL)
		return -1;

	(*jobs)[len].id = max_id(*jobs, len) + 1;
	(*jobs)[len].pid = pid;
	(*jobs)[len].etat = ACTIF;
	(*jobs)[len].commande = commande_string(commande);

	return len + 1;
}

/** Supprimer une tache à partir de son pid ou rien si le pid n'est pas attribué
 * @param jobs la liste des taches
 * @param len la longeur de jobs
 * @param pid le pid du processus de la tache
 * @return la nouvelle taille de jobs (len - 1 ou len) ou -1 si erreur
 */
int del_job_pid(struct job **jobs, int len, int pid)
{
	for (int i = 0; i < len; i++)
	{
		if ((*jobs)[i].pid == pid)
		{
			/* on n'oublie pas de libérer la chaine qui contient la commande */
			free((*jobs)[i].commande);

			/* on décale tous les éléments qui suivent */
			for (int j = i + 1; j < len; j++)
				(*jobs)[j - 1] = (*jobs)[j];

			len--;
			/* devrait toujours réussir car on diminue la taille */
			*jobs = realloc(*jobs, sizeof(struct job) * len);
		}
	}
	return len;
}

/** Mettre à jour le status d'une tache à partir de son pid (ou rien si pid pas attribué)
 * @param jobs la liste des taches
 * @param len la longueur de jobs
 * @param pid le pid du processus de la tache
 * @param etat le nouvel état du processus
 */
void update_status_job_pid(struct job **jobs, int len, int pid, enum state etat)
{
	for (int i = 0; i < len; i++)
	{
		if ((*jobs)[i].pid == pid)
			(*jobs)[i].etat = etat;
	}
}

/** Afficher toutes les taches en cours
 * @param jobs la liste des taches
 * @param len la longeur de jobs
 */
void print_jobs(struct job *jobs, int len)
{
	printf("id  pid   etat       commande\n");
	for (int i = 0; i < len; i++)
	{
		switch (jobs[i].etat)
		{
		case ACTIF:
			printf("[%d] %d ACTIF    > %s\n", jobs[i].id, jobs[i].pid, jobs[i].commande);
			break;
		case SUSPENDU:
			printf("[%d] %d SUSPENDU > %s\n", jobs[i].id, jobs[i].pid, jobs[i].commande);
			break;
		}
	}
}

/** Indique qu'un signal a été reçu si égal à true */
static bool got_signal;

/** Afficher le message du prompt et lire l'entrée. */
struct cmdline *prompt()
{
	struct cmdline *ligne;
	do
	{
		do
		{
			printf("pi-sh $ ");
			fflush(stdin);

			got_signal = false;
			/* ON A AUCUN MOYEN DE DISTINGUER UN EOF
			 * D'UNE ERREUR CAUSÉE PAR UN SIGNAL DONC ON
			 * UTILISE LA VARIABLE got_signal */
			ligne = readcmd();
		} while (got_signal);

		if (ligne == NULL)
		{
			return NULL;
		}

		if (ligne->err)
		{
			printf("erreur de lecture %s\n", ligne->err);
			return NULL;
		}

	} while (*(ligne->seq) == NULL);

	if (!strcmp(**(ligne->seq), "exit"))
		return NULL;

	return ligne;
}

/** Pid du processus en premier plan,
 * 0 indique qu'aucun processus n'est en premier plan */
static pid_t pid_fj;

/** Renvoyer le signal reçu au processus
 * en premier plan (signal handler) */
void send_signal_fj(int signal)
{
	/* on met un pid negatif pour kill tous les process du groupe */
	if (signal == SIGTSTP)
		kill(-pid_fj, SIGSTOP);
	else if (signal == SIGINT)
		kill(-pid_fj, SIGTERM);
	else
		kill(-pid_fj, signal);

	got_signal = true; /* informer qu'on a reçu un signal */
}

/* liste des taches en cours d'execution */
static struct job *jobs = NULL;
/* nombre de taches actuellement en cours */
static int jobs_number = 0;

/** Handler pour gérer le signal SIGCHLD */
void gerer_fils_handler()
{
	int pid_wait;	   /* pid récupéré par le wait */
	int status;		   /* status du fils */
	got_signal = true; /* informer qu'on a reçu un signal */

	/* on récupère le statut de tous les fils jusqu'à avoir une erreur
	 * car on ne reçoit le signal qu'une fois si plusieurs processus
	 * meurent en même temps. */
	while ((pid_wait = waitpid(-1, &status, WNOHANG | WUNTRACED)) > 0)
	{

		if (WIFSTOPPED(status))
		{
			update_status_job_pid(&jobs, jobs_number, pid_wait, SUSPENDU);
			printf("le processus de pid %d a été stoppé\n", pid_wait);
		}
		else
		{
			TEST_ERR(jobs_number = del_job_pid(&jobs, jobs_number, pid_wait))
			printf("fils de pid %d quitté avec le code %d\n", pid_wait, WEXITSTATUS(status));
		}

		if (pid_wait == pid_fj)
			pid_fj = 0; /* la tache en premier plan est stoppée */
	}

	if (pid_wait < 0)
	{
		switch (errno)
		{
		case ECHILD:
			/* si on a plus de fils on fait rien */
			break;
		default:
			perror("waitpid");
			exit(EXIT_FAILURE);
			break;
		}
	}
}

/** Attendre la fin de l'execution de la tache en premier plan
 * @param pid le pid de la tache à mettre en premier plan
 */
void attendre_tache_fg(int pid)
{

	/* structure utilisée pour gérer les signaux */
	struct sigaction traiterSig;
	sigemptyset(&(traiterSig.sa_mask));
	traiterSig.sa_flags = 0;

	/* gérer les signaux sigint et sigstop si on a un process en premier plan */
	pid_fj = pid; /* on met à jour le pid du processus en premier plan */

	tcsetpgrp(STDERR_FILENO, pid); /* changer le groupe en premier plan
									  (celui qui recevra les signaux du terminal) */
	do
		pause();
	while (pid_fj > 0);
	tcsetpgrp(STDERR_FILENO, getpgrp());

	/* on ignore à nouveau les signaux */
	traiterSig.sa_handler = SIG_IGN;
	sigaction(SIGINT, &traiterSig, NULL);
	sigaction(SIGTSTP, &traiterSig, NULL);
}

/** Lancer un fils.
 * @param pgid le pgid du groupe de processus
 *        (ou 0 pour utiliser le pid du nouveau fils, dans ce cas la valeur du groupe sera affectée à l'adresse donnée)
 * @param in entrée standard du fils
 * @param out sortie standard du fils ou -1 si on doit créer un nouveau pipe
 * @param args le tableau d'arguments pour exec
 * @return si on est dans le fils, cette fonction ne retourne pas.
 *         Dans le père: retourne le file descriptor de l'entrée du pipe créé si un pipe a été créé ou stdin
 */
int lancer_fils(pid_t *pgid, int in, int out, char **args)
{
	pid_t pid;
	/* structure utilisée pour gérer les signaux */
	struct sigaction traiterSig;
	sigemptyset(&(traiterSig.sa_mask));
	traiterSig.sa_flags = 0;

	/* créer un pipe si demandé */
	int tuyau[2];
	if (out < 0)
	{
		TEST_ERR(pipe(tuyau));
	}

	TEST_ERR(pid = fork());

	if (pid == 0)
	{
		/* Code du fils */

		if (out < 0)
		{
			/* on ferme le coté lecture */
			TEST_ERR(close(tuyau[0]));

			/* on utilise le pipe créé comme sortie standard */
			out = tuyau[1];
		}

		TEST_ERR(setpgid(getpid(), *pgid));

		/* remettre les handlers par défaut dans le fils */
		traiterSig.sa_handler = SIG_DFL;
		sigaction(SIGINT, &traiterSig, NULL);
		sigaction(SIGTSTP, &traiterSig, NULL);

		sigaction(SIGTTOU, &traiterSig, NULL);
		sigaction(SIGTTIN, &traiterSig, NULL);

		/* on remplace stdin par le fichier */
		TEST_ERR(dup2(in, STDIN_FILENO));

		/* on remplace stdout par le fichier */
		TEST_ERR(dup2(out, STDOUT_FILENO));

		execvp(args[0], args);
		perror("cannot start process");
		exit(EXIT_FAILURE);
	}

	/* =================== Code du père ==================== */
	/* on met à jour le pgid si celui-ci était inconnu */
	if (*pgid == 0)
		*pgid = pid;

	if (in != STDIN_FILENO)
	{
		/* on ferme in si c'est un file descriptor sur un fichier */
		TEST_ERR(close(in));
	}

	/* si on a créé un pipe */
	if (out < 0)
	{
		/* on ferme le coté écriture utilisé par le fils */
		TEST_ERR(close(tuyau[1]));

		/* on renvoie le côté lecture du pipe qu'on pourra réutiliser */
		return tuyau[0];
	}
	else if (out != STDOUT_FILENO)
	{
		/* on ferme out si c'est un file descriptor sur un fichier */
		TEST_ERR(close(out));
	}

	return STDIN_FILENO;
}

int main()
{
	/* structure utilisée pour gérer les signaux */
	struct sigaction traiterSig;
	sigemptyset(&(traiterSig.sa_mask));
	traiterSig.sa_flags = 0;

	/* définir le handler quand un fils meurt */
	traiterSig.sa_handler = gerer_fils_handler;
	sigaction(SIGCHLD, &traiterSig, NULL);

	traiterSig.sa_handler = SIG_IGN;
	sigaction(SIGINT, &traiterSig, NULL);
	sigaction(SIGTSTP, &traiterSig, NULL);

	/* on bloque ces signaux en + */
	sigaction(SIGTTOU, &traiterSig, NULL);
	sigaction(SIGTTIN, &traiterSig, NULL);

	/* la ligne lu après passage dans le parser */
	struct cmdline *ligne_commande;

	while ((ligne_commande = prompt()))
	{

		/* pour l'instant on ne regarde que le premier élément de seq */
		char **commande = *(ligne_commande->seq);

		if (!strcmp(commande[0], "cd"))
		{
			if (chdir(commande[1]) < 0)
				perror("cannot open directory");
			continue; /* ne pas lancer de fils ! */
		}

		if (!strcmp(commande[0], "lj"))
		{
			print_jobs(jobs, jobs_number);
			continue; /* ne pas lancer de fils ! */
		}

		if (!strcmp(commande[0], "sj"))
		{
			int id;

			if (commande[1] == NULL)
			{
				/* si on ne precise pas de numéro, on choisit la dernière tache lancée */
				id = jobs_number - 1;
			}
			else
			{

				char *out;
				id = strtol(commande[1], &out, 10);
				if (commande[1] == out)
				{ /* si rien n'a été lu */
					printf("you must give a valid number\n");
					continue;
				}
			}

			for (int i = 0; i < jobs_number; i++)
			{
				if (jobs[i].id == id)
					kill(-jobs[i].pid, SIGSTOP);
			}

			continue; /* ne pas lancer de fils ! */
		}

		if (!strcmp(commande[0], "susp"))
			kill(getpid(), SIGSTOP);

		if ((!strcmp(commande[0], "bg")) || (!strcmp(commande[0], "fg")))
		{
			int id;

			if (commande[1] == NULL)
			{
				/* si on ne precise pas de numéro, on choisit la dernière tache lancée */
				id = jobs_number - 1;
			}
			else
			{

				char *out;
				id = strtol(commande[1], &out, 10);
				if (commande[1] == out)
				{ /* si rien n'a été lu */
					printf("you must give a valid number\n");
					continue;
				}
			}

			for (int i = 0; i < jobs_number; i++)
			{
				if (jobs[i].id == id)
				{
					kill(-jobs[i].pid, SIGCONT);
					jobs[i].etat = ACTIF;

					if (!strcmp(commande[0], "fg")) /* si on met en premier plan, attendre la fin du process */
						attendre_tache_fg(jobs[i].pid);
				}
			}

			continue; /* ne pas lancer de fils ! */
		}

		/* lancer les fils */
		int in = STDIN_FILENO;			  /* entrée du pipeline */
		int pipeline_out = STDOUT_FILENO; /* sortie du pipeline */
		/* contiendra le pid du groupe de processus */
		pid_t pgid = 0;

		/* rediriger l'entrée du pipeline vers le fichier demandé */
		if (ligne_commande->in)
		{
			int fd_src;

			if ((fd_src = open(ligne_commande->in, O_RDONLY)) < 0)
			{
				perror("cannot open input file");
				continue; /* on ne lance pas de fils car erreur */
			}
			in = fd_src;
		}

		/* rediriger la sortie du pipeline vers le fichier demandé */
		if (ligne_commande->out)
		{
			int fd_dst;

			if ((fd_dst = open(ligne_commande->out,
							   O_WRONLY | O_TRUNC | O_CREAT,
							   S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)) < 0)
			{
				perror("cannot open output file");
				continue; /* on ne lance pas de fils car erreur */
			}
			pipeline_out = fd_dst;
		}

		char ***seq = ligne_commande->seq;
		while (*seq)
		{
			if (seq[1])
			{
				/* lancer un fils en redirigeant la sortie vers un nouveau pipe */
				in = lancer_fils(&pgid, in, -1, *seq);
			}
			else
			{
				/* on lance le dernier fils en redirigeant la sortie vers celle du pipeline */
				lancer_fils(&pgid, in, pipeline_out, *seq);
			}
			seq++;
		}

		/* Ajouter une tache à la liste des taches */
		TEST_ERR(jobs_number = add_job(&jobs, jobs_number, pgid, ligne_commande->seq));

		if (ligne_commande->backgrounded == NULL)
			attendre_tache_fg(pgid);
	}

	printf("sortie du shell\n");

	for (int i = 0; i < jobs_number; i++)
	{
		printf("kill du process %d\n", jobs[i].pid);
		kill(-jobs[i].pid, SIGKILL);
	}
	/* on ne wait pas car systemd s'en occupera :) */

	/* on n'oublie pas de libérer tout ce qu'il reste */
	free(jobs);

	return EXIT_SUCCESS;
}
