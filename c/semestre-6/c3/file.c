/**
 *  \author Xavier Cr�gut <nom@n7.fr>
 *  \file file.c
 *
 *  Objectif :
 *	Implantation des op�rations de la file
 */

#include <malloc.h>
#include <assert.h>

#include "file.h"

void initialiser(File *f)
{
    f->queue = NULL;
    f->tete = NULL;

    assert(est_vide(*f));
}

void detruire(File *f)
{
    free(f->tete);
    f->tete = NULL;
    free(f->queue);
    f->queue = NULL;
}

char tete(File f)
{
    assert(!est_vide(f));

    return f.tete->valeur;
}

bool est_vide(File f)
{
    return f.tete == NULL && f.queue == NULL;
}

/**
 * Obtenir une nouvelle cellule allou�e dynamiquement
 * initialis�e avec la valeur et la cellule suivante pr�cis� en param�tre.
 */
static Cellule *cellule(char valeur, Cellule *suivante)
{
    Cellule *new = (Cellule *)malloc(sizeof(Cellule));
    new->valeur = valeur;
    new->suivante = suivante;
    return new;
}

static int longueur_rec(Cellule *tete)
{
    if (tete == NULL)
    {
        return 0;
    }
    return 1 + longueur_rec(tete->suivante);
}

static void inserer_rec(Cellule *tete, Cellule *new)
{
    if (tete->suivante == NULL)
    {
        tete->suivante = new;
    }
    else
    {
        inserer_rec(tete->suivante, new);
    }
}

void inserer(File *f, char v)
{
    assert(f != NULL);

    Cellule *new = cellule(v, NULL);
    if (est_vide(*f))
    {
        f->tete = new;
    }
    else
    {
        inserer_rec(f->tete, new);
    }
}



void extraire(File *f, char *v)
{
    assert(f != NULL);
    assert(!est_vide(*f));

    *v = f->tete->valeur;
    f->tete = f->tete->suivante;
}

int longueur(File f)
{
    return longueur_rec(f.tete);
}
