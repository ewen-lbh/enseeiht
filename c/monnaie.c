#include <stddef.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <assert.h>
#define TAILLE_PORTE_MONNAIE 5

struct monnaie {
    int valeur;
    char devise;
};


struct monnaie init_monnaie(int valeur, char devise) {
    if (valeur < 0) exit(1);

    struct monnaie m = {valeur, devise};
    // m->valeur = valeur;
    // // m->devise = devise;
    return m;
}

bool add(struct monnaie* m1, struct monnaie* m2) {
    if (m1->devise != m2->devise) return false;

    m2->valeur += m1->valeur;
    return true;
}

void test() {
    struct monnaie usd3 = init_monnaie(3, '$');
    struct monnaie eur8 = init_monnaie(8, 'e');
    struct monnaie eur10 = init_monnaie(10, 'e');
    assert(3 == usd3.valeur);
    assert(false == add(&usd3, &eur8));
    assert(true == add(&eur8, &eur10));
    assert(18 == eur10.valeur);
    assert(8 == eur8.valeur);
    assert('e' == eur10.devise);
}

void print_porte_monnaie(struct monnaie* porte_monnaie) {
    for (int i = 0; i < TAILLE_PORTE_MONNAIE; i++) {
        printf("· %d%c\n", porte_monnaie[i].valeur, porte_monnaie[i].devise);
    }
}

int main() {
    test();

    struct monnaie porte_monnaie[TAILLE_PORTE_MONNAIE];
    struct monnaie somme = init_monnaie(0, ' ');
    
    for (int i = 0; i < TAILLE_PORTE_MONNAIE; i++) {
        int valeur;
        char devise;
        scanf(" %d", &valeur);
        scanf(" %c", &devise);
        porte_monnaie[i] = init_monnaie(valeur, devise);
        print_porte_monnaie(porte_monnaie);
    }

    printf("\n Somme des monnaies en? ");
    char devise;
    scanf(" %c", &devise);
    somme = init_monnaie(0, devise);
    for (int i = 0; i < TAILLE_PORTE_MONNAIE; i++) {
        if (porte_monnaie[i].devise == devise) {
            add(&porte_monnaie[i], &somme);
        }
    }

    printf("Somme: %d %c", somme.valeur, somme.devise);

    return 0;
}
