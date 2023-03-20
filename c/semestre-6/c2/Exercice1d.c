

#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// Consignes pour une obtenir une exécution sans erreur :
//     - compléter les instruction **** TODO ****
// Attention : toutes les variables sont ici allouées et libérées dynamiquent

int main()
{
    char *chaine = malloc(9 * sizeof(char *)); // une chaine de caractère dynamique
    // Allocation pour pouvoir y copier la chaine constante "LANGAGE_C"
    // à l'aide de la procédure strcpy() de string.h

    strcpy(chaine, "LANGAGE_C");
    assert(strcmp(chaine, "LANGAGE_C") == 0);
    assert(0 [chaine] == 'L');
    assert(9 [chaine] == '\0');

    //**** TODO ****
    // Libérer toute la mémoire dynamique
    free(chaine);
    chaine = NULL;
    assert(!chaine);
    //---------

    printf("%s", "Bravo ! Tous les tests passent.\n");
    return EXIT_SUCCESS;
}
