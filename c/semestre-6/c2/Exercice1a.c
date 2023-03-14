
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>

// Consignes pour une obtenir une exécution sans erreur :
//     - Récupérer la taille du type
//     - Allouer de la mémoire
//     - Initialiser la mémoire allouée
//     - Libérer la mémoire allouée
//     - Mettre le pointeur à NULL
// Attention : toutes les variables sont ici allouées et libérées dynamiquent

int main()
{

    // Allocation et initialisation à la valeur 100;
    int *ptr_int = malloc(sizeof(int *));
    *ptr_int = 100;
    assert(*ptr_int == 100);

    // Libérer toute la mémoire dynamique
    free(ptr_int);
    ptr_int = NULL;

    assert(!ptr_int);

    printf("%s", "Bravo ! Tous les tests passent.\n");
    return EXIT_SUCCESS;
}
