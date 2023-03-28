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
    return f.tete == NULL;
}

/**
 * Obtenir une nouvelle cellule allou�e dynamiquement
 * initialis�e avec la valeur et la cellule suivante pr�cis� en param�tre.
 */
static Cellule *cellule(char valeur, Cellule *suivante)
{
    return &(Cellule){.suivante = suivante, .valeur = valeur};
}

void inserer(File *f, char v)
{
    assert(f != NULL);

    Cellule *new_cell = cellule(v, f->tete);
    f->tete = new_cell;
}

void extraire(File *f, char *v)
{
    assert(f != NULL);
    assert(!est_vide(*f));

    // TODO
}

int longueur(File f)
{
    Cellule *current = f.tete;
    int length = 0;
    while (current != NULL)
    {
        length++;
        current = current->suivante;
    }
    return length;
}
