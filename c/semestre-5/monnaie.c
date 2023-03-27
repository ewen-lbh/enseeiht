#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <stdbool.h>
#define TAILLE_PORTE_MONNAIE 5

struct monnaie
{
    int valeur;
    char devise;
};

/**
 * \brief Initialiser une monnaie
 * \param[in] valeur    montant dans la devise
 * \param[in] devise    caractère représentant la devise
 * \pre valeur >= 0
 */
struct monnaie init_monnaie(int valeur, char devise)
{
    if (valeur < 0)
        exit(1);

    struct monnaie m = {valeur, devise};
    return m;
}

/**
 * \brief Ajouter une monnaie m2 à une monnaie m1
 * \param[in out] m1    monnaie m1
 * \param[in] m2        monnaie m2
 */
bool ajouter(struct monnaie *m1, struct monnaie *m2)
{
    if (m1->devise != m2->devise)
        return false;

    m2->valeur += m1->valeur;
    return true;
}

/**
 * \brief Tester Initialiser
 * \param[]
 */
void tester_initialiser()
{
    struct monnaie usd3 = init_monnaie(3, '$');
    struct monnaie eur8 = init_monnaie(8, 'e');
    struct monnaie eur10 = init_monnaie(10, 'e');
    assert(3 == usd3.valeur);
    assert(8 == eur8.valeur);
    assert(10 == eur10.valeur);
    assert('$' == usd3.devise);
    assert('e' == eur8.devise);
    assert('e' == eur10.devise);
}

/**
 * \brief Tester Ajouter
 * \param[]
 */
void tester_ajouter()
{
    struct monnaie usd3 = init_monnaie(3, '$');
    struct monnaie eur8 = init_monnaie(8, 'e');
    struct monnaie eur10 = init_monnaie(10, 'e');
    assert(false == ajouter(&usd3, &eur8));
    assert(true == ajouter(&eur8, &eur10));
    assert(18 == eur10.valeur);
    assert(8 == eur8.valeur);
    assert('e' == eur10.devise);
}

/**
 * \brief Affiche de manière conviviale le contenu d'un porte monnaie
 * \param[in] porte_monnaie     le porte-monnaie à afficher
 */
void print_porte_monnaie(struct monnaie *porte_monnaie)
{
    for (int i = 0; i < TAILLE_PORTE_MONNAIE; i++)
    {
        printf("· %d%c\n", porte_monnaie[i].valeur, porte_monnaie[i].devise);
    }
}

int main()
{
    tester_initialiser();
    tester_ajouter();

    struct monnaie porte_monnaie[TAILLE_PORTE_MONNAIE];
    struct monnaie somme = init_monnaie(0, ' ');

    for (int i = 0; i < TAILLE_PORTE_MONNAIE; i++)
    {
        int valeur;
        char devise;
        scanf(" %d", &valeur);
        scanf(" %c", &devise);
        porte_monnaie[i] = init_monnaie(valeur, devise);
    }

    printf("\n Somme des monnaies en? ");
    char devise;
    scanf(" %c", &devise);
    somme = init_monnaie(0, devise);
    bool success = true;
    for (int i = 0; i < TAILLE_PORTE_MONNAIE; i++)
    {
        if (porte_monnaie[i].devise == devise)
        {
            success = success && ajouter(&porte_monnaie[i], &somme);
        }
    }

    if (success)
    {
        printf("Somme: %d %c\n", somme.valeur, somme.devise);
        return 0;
    }
    else
    {
        printf("Une erreur s'est produite.\n");
        return 1;
    }
}
